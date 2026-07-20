//! Format-string → regex lowering and a `RegexSet`-backed log scanner.
//!
//! The `Scan` surface (see `notes/design.md` §3) resolves a *rendered* log line
//! — the concrete text a user actually saw — back to the `%s`-parameterized
//! format string in the index, and thus to its source call site.
//!
//! The mechanism has two halves:
//!
//! 1. **Lowering** ([`lower_format`]) turns a Postgres/C `printf`/`errmsg`
//!    format string into an anchored regex: literal runs are escaped verbatim,
//!    each conversion spec (`%s`, `%d`, `%m`, width/precision/positional forms)
//!    becomes a capture group sized to what it can render.
//! 2. **Scanning** ([`Scanner`]) compiles every lowered pattern into a
//!    `Vec<Regex>` and builds a **trigram prefilter** over each pattern's literal
//!    runs (the same algorithm as the hand-tuned TS `ScanIndex` in
//!    `site/src/scanner.ts`). A line is resolved by extracting its trigrams,
//!    unioning the candidate patterns that share a trigram (plus a small
//!    "always-check" set for patterns with no usable literal run — including bare
//!    `%s`-style catch-alls), then running each candidate's `Regex::captures` to
//!    confirm the match and pull the variable bits out. Because every literal run
//!    must appear verbatim in any matching line, the prefilter is *sound*: it
//!    only narrows the candidate set, and the real regex still verifies — so the
//!    results are identical to the historical [`regex::RegexSet`] path (kept as
//!    [`Scanner::scan_line_regexset`] for the equivalence cross-check).
//!
//! Unlike the TS scanner, the Rust `Scanner` stays *ground truth*: it does NOT
//! exclude bare catch-alls or strip a log prefix — those are TS-side product
//! choices. Catch-alls land in the always-check set and are reported like any
//! other match.
//!
//! [`render_sample`] is the inverse used for round-trip testing and for
//! synthesizing a sample log from the catalog: it fills each conversion spec
//! with a plausible concrete value, producing a line the lowering must match.

use std::collections::HashMap;

use regex::{Regex, RegexSet, RegexSetBuilder};

use crate::Index;

/// Push the lowercase 3-char trigrams of `s` onto `out` (nothing for `s`
/// shorter than 3 chars). Mirrors the TS `trigrams()` in `site/src/scanner.ts`:
/// lowercase, then every length-3 sliding window. Char-based (not byte-based)
/// so it is UTF-8 safe; lowercasing both the pattern literals and the scanned
/// line keeps the prefilter sound (a verbatim literal in the line always yields
/// its lowercased trigrams).
fn push_trigrams(s: &str, out: &mut Vec<String>) {
    let lower = s.to_lowercase();
    let chars: Vec<char> = lower.chars().collect();
    for w in chars.windows(3) {
        out.push(w.iter().collect());
    }
}

/// Why a format string could not be lowered to a regex.
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum LowerError {
    /// A trailing `%` with no conversion character after it.
    DanglingPercent,
    /// A conversion character the lowering does not understand.
    UnknownConversion(char),
}

impl std::fmt::Display for LowerError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            LowerError::DanglingPercent => write!(f, "format string ends with a dangling '%'"),
            LowerError::UnknownConversion(c) => write!(f, "unknown conversion specifier '%{c}'"),
        }
    }
}

impl std::error::Error for LowerError {}

/// A format string lowered to a regex, plus a couple of specificity signals.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Lowered {
    /// The anchored regex source (`^…$`).
    pub regex: String,
    /// Count of *literal* characters (everything that is not a conversion
    /// spec's capture group). This is the specificity signal used to rank
    /// competing matches — a bare `"%s"` has `literal_len == 0` and matches
    /// everything, whereas `database "%s" does not exist` has 25.
    pub literal_len: usize,
    /// Number of conversion specs (capture groups) in the pattern.
    pub spec_count: usize,
    /// The conversion character for each capture group, in order.
    /// `database "%s" does not exist` yields `["s"]`; `%d of %d tuples` yields
    /// `["d", "d"]`. `%n` and `%%` contribute no group and no entry. Mirrors the
    /// TS `Lowered.groups` (see `site/src/lower.ts`) so bindings can label each
    /// extracted value with the `%`-spec it came from.
    pub groups: Vec<String>,
    /// The maximal literal runs between conversion specs (each unescaped, `%%`
    /// folded to `%`). Every one of these must appear verbatim in any line the
    /// pattern matches, so the scanner uses them to build a sound trigram
    /// prefilter. `database "%s" does not exist` yields
    /// `['database "', '" does not exist']`. Mirrors the TS `Lowered.literals`.
    pub literals: Vec<String>,
}

/// Consume a field-width-style token starting at `chars[i]`: a single `*`
/// (argument-supplied width) or a run of decimal digits. Returns the index
/// just past it, or `i` unchanged when neither is present. Shared by the field
/// width and precision parsers, which accept the same token.
fn consume_width(chars: &[char], mut i: usize) -> usize {
    if i < chars.len() && chars[i] == '*' {
        i += 1;
    } else {
        while i < chars.len() && chars[i].is_ascii_digit() {
            i += 1;
        }
    }
    i
}

/// Consume a `printf`-style conversion spec that begins at `chars[start]`
/// (which must be `%`, and not the start of `%%`). Returns the conversion
/// character and the index just past the whole spec.
fn parse_spec(chars: &[char], start: usize) -> Result<(char, usize), LowerError> {
    let mut i = start + 1; // skip '%'

    // Positional argument: digits followed by '$'.
    let mut j = i;
    while j < chars.len() && chars[j].is_ascii_digit() {
        j += 1;
    }
    if j > i && j < chars.len() && chars[j] == '$' {
        i = j + 1;
    }
    // Flags.
    while i < chars.len() && matches!(chars[i], '-' | '+' | ' ' | '0' | '#' | '\'') {
        i += 1;
    }
    // Field width: a run of digits or a single '*' (argument-supplied width).
    i = consume_width(chars, i);
    // Precision: '.' then digits or '*'.
    if i < chars.len() && chars[i] == '.' {
        i += 1;
        i = consume_width(chars, i);
    }
    // Length modifier: hh, ll (two-char) then h, l, L, q, j, z, t (one-char).
    if i + 1 < chars.len() && (chars[i] == 'h' || chars[i] == 'l') && chars[i + 1] == chars[i] {
        i += 2;
    } else if i < chars.len() && matches!(chars[i], 'h' | 'l' | 'L' | 'q' | 'j' | 'z' | 't') {
        i += 1;
    }
    // Conversion.
    if i >= chars.len() {
        return Err(LowerError::DanglingPercent);
    }
    Ok((chars[i], i + 1))
}

/// The regex fragment a conversion character lowers to, or `None` for `%n`
/// (which writes nothing to the output) and `Err` for anything unrecognized.
fn conversion_group(conv: char) -> Result<Option<&'static str>, LowerError> {
    let group = match conv {
        's' => "(.*?)",
        'd' | 'i' => r"(-?\d+)",
        'u' => r"(\d+)",
        'o' => r"([0-7]+)",
        'x' | 'X' => r"([0-9a-fA-F]+)",
        'e' | 'E' | 'f' | 'F' | 'g' | 'G' | 'a' | 'A' => r"([-+0-9.eEpPxXaAfFnN]+)",
        'c' => "(.)",
        'p' => r"(0x[0-9a-fA-F]+|\(nil\))",
        // Postgres %m expands to strerror(errno) — arbitrary prose.
        'm' => "(.+?)",
        'n' => return Ok(None),
        other => return Err(LowerError::UnknownConversion(other)),
    };
    Ok(Some(group))
}

/// Lower a Postgres/C `printf`-style format string into an anchored regex.
///
/// Literal runs are `regex::escape`d; each conversion spec becomes a capture
/// group. Width, precision, flags, length modifiers and positional (`%1$s`)
/// forms are parsed and discarded — they affect rendering, not what characters
/// can appear — so `%-5s`, `%.2f`, `%03d`, `%*d`, `%1$s` all lower like their
/// bare form. `%%` becomes a literal `%`.
pub fn lower_format(fmt: &str) -> Result<Lowered, LowerError> {
    let chars: Vec<char> = fmt.chars().collect();
    let mut out = String::from("^");
    let mut literal = String::new();
    let mut literal_len = 0usize;
    let mut spec_count = 0usize;
    let mut groups: Vec<String> = Vec::new();
    let mut literals: Vec<String> = Vec::new();
    let mut i = 0;

    fn flush(literal: &mut String, out: &mut String, literals: &mut Vec<String>) {
        if !literal.is_empty() {
            out.push_str(&regex::escape(literal));
            literals.push(std::mem::take(literal));
        }
    }

    while i < chars.len() {
        let c = chars[i];
        if c != '%' {
            literal.push(c);
            literal_len += 1;
            i += 1;
            continue;
        }
        // A '%'. Handle the '%%' literal-percent case first.
        if i + 1 < chars.len() && chars[i + 1] == '%' {
            literal.push('%');
            literal_len += 1;
            i += 2;
            continue;
        }
        let (conv, next) = parse_spec(&chars, i)?;
        if let Some(group) = conversion_group(conv)? {
            flush(&mut literal, &mut out, &mut literals);
            out.push_str(group);
            spec_count += 1;
            groups.push(conv.to_string());
        }
        i = next;
    }
    flush(&mut literal, &mut out, &mut literals);
    out.push('$');
    Ok(Lowered {
        regex: out,
        literal_len,
        spec_count,
        groups,
        literals,
    })
}

/// Render a format string with canned, plausible values — the inverse of
/// [`lower_format`], used to synthesize sample log lines and to round-trip test
/// the lowering. Returns `None` if the format contains a spec that lowering
/// itself would reject.
pub fn render_sample(fmt: &str) -> Option<String> {
    let chars: Vec<char> = fmt.chars().collect();
    let mut out = String::new();
    let mut i = 0;
    while i < chars.len() {
        let c = chars[i];
        if c != '%' {
            out.push(c);
            i += 1;
            continue;
        }
        if i + 1 < chars.len() && chars[i + 1] == '%' {
            out.push('%');
            i += 2;
            continue;
        }
        let (conv, next) = parse_spec(&chars, i).ok()?;
        let value = match conv {
            's' => "widget",
            'd' | 'i' => "42",
            'u' => "42",
            'o' => "52",
            'x' => "2a",
            'X' => "2A",
            'e' | 'E' | 'f' | 'F' | 'g' | 'G' | 'a' | 'A' => "1.5",
            'c' => "Q",
            'p' => "0x55a0",
            'm' => "No such file or directory",
            'n' => "",
            _ => return None,
        };
        out.push_str(value);
        i = next;
    }
    Some(out)
}

/// A single resolved match: the catalog site a line was traced back to, its
/// specificity, and the concrete values pulled from the line's variable bits.
#[derive(Debug, Clone)]
pub struct MatchHit {
    /// Index into [`Index::sites`].
    pub site: usize,
    /// Literal-char count of the matched pattern (higher = more specific).
    pub literal_len: usize,
    /// Captured group values, in order (empty string for an unmatched
    /// optional group).
    pub captures: Vec<String>,
}

/// The `(start, end)` fields of an unmatched optional capture group in a
/// [`MatchHitSpans`] — a group the pattern has but this line did not fill.
/// Slicing a line by such a span must yield `""` (the same value
/// [`MatchHit::captures`] carries for an unmatched group); consumers test
/// `start == NO_SPAN` and substitute `""`.
pub const NO_SPAN: usize = usize::MAX;

/// The span-valued twin of [`MatchHit`]: instead of owning each captured group
/// as a `String`, it records the group's `(start, end)` **byte range in the
/// scanned line**. Slicing `line[start..end]` reproduces the corresponding
/// [`MatchHit::captures`] entry exactly; an unmatched optional group is
/// `(NO_SPAN, NO_SPAN)` and slices to `""`.
///
/// This is the allocation-free hit shape the packed wasm scan path encodes into
/// one flat numeric buffer — no per-capture `String`, so nothing has to be
/// serialized across the wasm boundary; the caller reconstructs the strings by
/// slicing the input line it already holds.
#[derive(Debug, Clone)]
pub struct MatchHitSpans {
    /// Index into [`Index::sites`] (identical to [`MatchHit::site`]).
    pub site: usize,
    /// Literal-char count of the matched pattern (identical to
    /// [`MatchHit::literal_len`]).
    pub literal_len: usize,
    /// Byte `(start, end)` of each capture group in the scanned line, in order.
    /// An unmatched optional group is `(NO_SPAN, NO_SPAN)`.
    ///
    /// NB: these are UTF-8 **byte** offsets. A JS consumer indexing UTF-16 code
    /// units must convert for lines with non-BMP/non-ASCII text; for ASCII lines
    /// the two coincide.
    pub captures: Vec<(usize, usize)>,
}

/// What happened while building a [`Scanner`] over an index — every site is
/// accounted for exactly once across these buckets.
#[derive(Debug, Clone, Default, PartialEq, Eq)]
pub struct BuildReport {
    /// Sites in the index.
    pub total: usize,
    /// Skipped: no literal `message.text` to lower (computed-only / `expr`).
    pub no_text: usize,
    /// Had text, but lowering rejected it.
    pub lower_failed: usize,
    /// Lowered, but the regex failed to compile.
    pub compile_failed: usize,
    /// Sites that produced a live pattern in the set.
    pub compiled: usize,
}

/// A trigram-prefiltered scanner over every lowered catalog pattern.
///
/// Each pattern keeps its compiled [`Regex`] (for capture extraction) plus its
/// site provenance and literal length. The prefilter maps each pattern to the
/// *rarest* trigram of its literal runs (the `pg_trgm` trick — smaller, more
/// balanced buckets); patterns with no literal run ≥3 chars (short literals and
/// bare catch-alls) go in an `always_check` set. A [`RegexSet`] over the same
/// patterns is retained so [`Scanner::scan_line_regexset`] can cross-check the
/// prefilter against the exhaustive path.
pub struct Scanner {
    set: RegexSet,
    regexes: Vec<Regex>,
    site_idx: Vec<usize>,
    literal_len: Vec<usize>,
    /// trigram → indices of patterns anchored on it (each in exactly one bucket).
    buckets: HashMap<String, Vec<usize>>,
    /// Patterns with no usable trigram (literal runs all <3 chars, or none) —
    /// checked against every line. Includes bare `%s`-style catch-alls.
    always_check: Vec<usize>,
}

impl Scanner {
    /// Lower every site with a literal message, compile the patterns, and build
    /// the trigram prefilter (and the `RegexSet` retained for cross-check).
    /// Returns the scanner and a [`BuildReport`] tallying what was lowered,
    /// skipped, or failed.
    pub fn build(index: &Index) -> Result<(Scanner, BuildReport), regex::Error> {
        let mut report = BuildReport {
            total: index.sites.len(),
            ..Default::default()
        };
        let mut patterns: Vec<String> = Vec::new();
        let mut regexes: Vec<Regex> = Vec::new();
        let mut site_idx: Vec<usize> = Vec::new();
        let mut literal_len: Vec<usize> = Vec::new();
        // The unique trigrams of each compiled pattern's literal runs, kept so we
        // can pick each pattern's rarest anchor after the global freq is tallied.
        let mut per_pattern: Vec<Vec<String>> = Vec::new();
        let mut freq: HashMap<String, usize> = HashMap::new();

        for (idx, site) in index.sites.iter().enumerate() {
            let text = match site.message.text.as_deref() {
                Some(t) if !t.is_empty() => t,
                _ => {
                    report.no_text += 1;
                    continue;
                }
            };
            let lowered = match lower_format(text) {
                Ok(l) => l,
                Err(_) => {
                    report.lower_failed += 1;
                    continue;
                }
            };
            let re = match Regex::new(&lowered.regex) {
                Ok(re) => re,
                Err(_) => {
                    report.compile_failed += 1;
                    continue;
                }
            };

            // Unique trigrams across this pattern's literal runs, tallied into
            // the global frequency table for rarest-anchor selection.
            let mut tris: Vec<String> = Vec::new();
            for lit in &lowered.literals {
                push_trigrams(lit, &mut tris);
            }
            tris.sort_unstable();
            tris.dedup();
            for t in &tris {
                *freq.entry(t.clone()).or_insert(0) += 1;
            }

            patterns.push(lowered.regex);
            regexes.push(re);
            site_idx.push(idx);
            literal_len.push(lowered.literal_len);
            per_pattern.push(tris);
        }
        report.compiled = patterns.len();

        // Anchor each pattern under its rarest trigram; patterns with none go in
        // the always-check set (short-literal patterns and bare catch-alls).
        let mut buckets: HashMap<String, Vec<usize>> = HashMap::new();
        let mut always_check: Vec<usize> = Vec::new();
        for (i, tris) in per_pattern.iter().enumerate() {
            if tris.is_empty() {
                always_check.push(i);
                continue;
            }
            // Rarest trigram wins; ties broken by the smallest trigram so the
            // choice is deterministic.
            let best = tris
                .iter()
                .min_by(|a, b| {
                    freq[*a]
                        .cmp(&freq[*b])
                        .then_with(|| a.as_str().cmp(b.as_str()))
                })
                .expect("non-empty");
            buckets.entry(best.clone()).or_default().push(i);
        }

        // Generous limits: ~14k anchored patterns overflow the default budget.
        let set = RegexSetBuilder::new(&patterns)
            .size_limit(1 << 30)
            .dfa_size_limit(1 << 30)
            .build()?;

        Ok((
            Scanner {
                set,
                regexes,
                site_idx,
                literal_len,
                buckets,
                always_check,
            },
            report,
        ))
    }

    /// Number of live patterns in the scanner.
    pub fn pattern_count(&self) -> usize {
        self.regexes.len()
    }

    /// Number of patterns held in the always-check set (no usable trigram —
    /// short-literal patterns and bare `%s`-style catch-alls).
    pub fn always_check_count(&self) -> usize {
        self.always_check.len()
    }

    /// How many candidate patterns the prefilter would verify for `line` — the
    /// prefilter's selectivity (a diagnostic for benchmarking; the smaller
    /// relative to `pattern_count`, the more the prefilter narrows).
    pub fn candidate_count(&self, line: &str) -> usize {
        self.candidate_indices(line).len()
    }

    /// Union of candidate pattern indices for `line`: every prefilter bucket that
    /// shares a trigram with the (lowercased) line, plus the always-check set —
    /// deduped and ascending. Shared by [`scan_line`], [`scan_line_spans`], and
    /// [`candidate_count`] so all three prefilter identically. The line is
    /// lowercased ONCE and each 3-char window is looked up as a borrowed `&str`
    /// (`HashMap<String>::get` accepts `&str` via `Borrow`), so no per-trigram
    /// strings are allocated.
    ///
    /// [`scan_line`]: Scanner::scan_line
    /// [`scan_line_spans`]: Scanner::scan_line_spans
    fn candidate_indices(&self, line: &str) -> Vec<usize> {
        let lower = line.to_lowercase();
        let mut candidates: Vec<usize> = Vec::new();
        // Byte offsets of each char boundary, plus the end, so a length-3 char
        // window is `lower[bounds[k]..bounds[k + 3]]`.
        let bounds: Vec<usize> = lower
            .char_indices()
            .map(|(i, _)| i)
            .chain(std::iter::once(lower.len()))
            .collect();
        if bounds.len() > 3 {
            for k in 0..bounds.len() - 3 {
                if let Some(bucket) = self.buckets.get(&lower[bounds[k]..bounds[k + 3]]) {
                    candidates.extend_from_slice(bucket);
                }
            }
        }
        candidates.extend_from_slice(&self.always_check);
        // Ascending pattern-index order (then a *stable* literal_len sort by the
        // caller) reproduces the RegexSet path's ordering exactly.
        candidates.sort_unstable();
        candidates.dedup();
        candidates
    }

    /// Verify candidate pattern `pi` against `line`, producing a [`MatchHit`]
    /// (with captures) when it matches. Shared by both scan paths so their hit
    /// shape is byte-identical.
    fn verify(&self, pi: usize, line: &str) -> Option<MatchHit> {
        let caps = self.regexes[pi].captures(line)?;
        let captures = caps
            .iter()
            .skip(1)
            .map(|m| m.map(|mm| mm.as_str().to_string()).unwrap_or_default())
            .collect();
        Some(MatchHit {
            site: self.site_idx[pi],
            literal_len: self.literal_len[pi],
            captures,
        })
    }

    /// Resolve one rendered log line to every catalog site whose pattern
    /// matches it, most-specific (longest literal) first, via the **trigram
    /// prefilter**. An empty result means no site matched; more than one means
    /// the line is ambiguous.
    ///
    /// The prefilter narrows the candidate patterns to those sharing a trigram
    /// with the line (plus the always-check set); each candidate's real `Regex`
    /// still verifies, so the result is identical to
    /// [`Scanner::scan_line_regexset`] — this is a pure speed optimization.
    pub fn scan_line(&self, line: &str) -> Vec<MatchHit> {
        // Verify in ascending pattern-index order, then a *stable* sort by
        // descending literal_len — this reproduces the RegexSet path's ordering
        // exactly (RegexSet also yields ascending indices, ties preserved).
        let mut hits: Vec<MatchHit> = self
            .candidate_indices(line)
            .iter()
            .filter_map(|&pi| self.verify(pi, line))
            .collect();
        hits.sort_by_key(|h| std::cmp::Reverse(h.literal_len));
        hits
    }

    /// Verify candidate pattern `pi` against `line`, producing a
    /// [`MatchHitSpans`] (capture **byte spans** rather than owned strings) when
    /// it matches. The span twin of [`Scanner::verify`]: identical site /
    /// literal_len / group order, but each capture is the group's `(start, end)`
    /// byte range in `line` (an unmatched optional group is `(NO_SPAN, NO_SPAN)`).
    fn verify_spans(&self, pi: usize, line: &str) -> Option<MatchHitSpans> {
        let caps = self.regexes[pi].captures(line)?;
        let captures = caps
            .iter()
            .skip(1)
            .map(|m| {
                m.map(|mm| (mm.start(), mm.end()))
                    .unwrap_or((NO_SPAN, NO_SPAN))
            })
            .collect();
        Some(MatchHitSpans {
            site: self.site_idx[pi],
            literal_len: self.literal_len[pi],
            captures,
        })
    }

    /// Resolve one rendered log line exactly like [`scan_line`], but return each
    /// hit's captures as **byte spans into `line`** ([`MatchHitSpans`]) rather
    /// than owned `String`s. Same prefilter, same candidates, same specificity
    /// ordering — so `scan_line_spans(line)[i]` describes the identical match as
    /// `scan_line(line)[i]`, with `line[start..end] == scan_line(line)[i].captures[k]`
    /// for every group (`NO_SPAN` ⇒ `""`).
    ///
    /// This exists for callers that will reconstruct the capture strings
    /// themselves (they already hold `line`) and want to avoid allocating and
    /// marshalling those strings — notably the packed wasm scan path, which
    /// encodes these spans into one flat numeric buffer instead of a nested list
    /// of JS objects.
    ///
    /// [`scan_line`]: Scanner::scan_line
    pub fn scan_line_spans(&self, line: &str) -> Vec<MatchHitSpans> {
        let mut hits: Vec<MatchHitSpans> = self
            .candidate_indices(line)
            .iter()
            .filter_map(|&pi| self.verify_spans(pi, line))
            .collect();
        hits.sort_by_key(|h| std::cmp::Reverse(h.literal_len));
        hits
    }

    /// Resolve one rendered log line via the exhaustive [`RegexSet`] path (no
    /// prefilter). Retained as the ground-truth cross-check for [`scan_line`];
    /// the two MUST return identical `Vec<MatchHit>` for every line.
    ///
    /// [`scan_line`]: Scanner::scan_line
    pub fn scan_line_regexset(&self, line: &str) -> Vec<MatchHit> {
        let mut hits: Vec<MatchHit> = self
            .set
            .matches(line)
            .into_iter()
            .filter_map(|pi| self.verify(pi, line))
            .collect();
        hits.sort_by_key(|h| std::cmp::Reverse(h.literal_len));
        hits
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn lower(fmt: &str) -> Lowered {
        lower_format(fmt).unwrap()
    }

    #[test]
    fn escapes_literals_and_lowers_string_spec() {
        let l = lower(r#"database "%s" does not exist"#);
        assert_eq!(l.regex, r#"^database "(.*?)" does not exist$"#);
        assert_eq!(l.spec_count, 1);
        let re = Regex::new(&l.regex).unwrap();
        let caps = re.captures(r#"database "orders" does not exist"#).unwrap();
        assert_eq!(&caps[1], "orders");
    }

    // `groups`/`literals` must byte-match the TS `lowerFormat` output
    // (site/src/lower.ts, oracle site/src/lower.test.ts) so the trigram index
    // built either side is the same.
    #[test]
    fn groups_and_literals_mirror_the_ts_lowering() {
        let l = lower(r#"database "%s" does not exist"#);
        assert_eq!(l.groups, vec!["s".to_string()]);
        assert_eq!(
            l.literals,
            vec![
                r#"database ""#.to_string(),
                r#"" does not exist"#.to_string()
            ]
        );

        let l = lower("%d of %d tuples");
        assert_eq!(l.groups, vec!["d".to_string(), "d".to_string()]);
        assert_eq!(l.literals, vec![" of ".to_string(), " tuples".to_string()]);

        let l = lower(r#"could not open file "%s": %m"#);
        assert_eq!(l.groups, vec!["s".to_string(), "m".to_string()]);
        assert_eq!(
            l.literals,
            vec![r#"could not open file ""#.to_string(), r#"": "#.to_string()]
        );

        // `%%` folds to a literal `%` inside the run; a bare `%s` has no literal.
        let l = lower("disk is %d%% full");
        assert_eq!(l.groups, vec!["d".to_string()]);
        assert_eq!(
            l.literals,
            vec!["disk is ".to_string(), "% full".to_string()]
        );

        let l = lower("%s");
        assert!(l.groups == vec!["s".to_string()]);
        assert!(l.literals.is_empty(), "bare catch-all has no literal run");

        // `%n` writes nothing: no group, and the literal run spans across it.
        let l = lower("count%n done");
        assert!(l.groups.is_empty());
        assert_eq!(l.literals, vec!["count done".to_string()]);
    }

    #[test]
    fn bare_string_spec_matches_anything() {
        let l = lower("%s");
        assert_eq!(l.regex, "^(.*?)$");
        assert_eq!(l.literal_len, 0);
        assert!(Regex::new(&l.regex).unwrap().is_match("literally anything"));
    }

    #[test]
    fn lowers_integers_and_repeated_specs() {
        let l = lower("%d of %d tuples");
        assert_eq!(l.regex, r"^(-?\d+) of (-?\d+) tuples$");
        let re = Regex::new(&l.regex).unwrap();
        let caps = re.captures("7 of 512 tuples").unwrap();
        assert_eq!(&caps[1], "7");
        assert_eq!(&caps[2], "512");
        assert!(re.captures("-3 of 4 tuples").is_some());
    }

    #[test]
    fn lowers_percent_m_and_quoted_string() {
        let l = lower(r#"could not open file "%s": %m"#);
        assert_eq!(l.regex, r#"^could not open file "(.*?)": (.+?)$"#);
        let re = Regex::new(&l.regex).unwrap();
        let caps = re
            .captures(r#"could not open file "pg_wal/000001": No such file or directory"#)
            .unwrap();
        assert_eq!(&caps[1], "pg_wal/000001");
        assert_eq!(&caps[2], "No such file or directory");
    }

    #[test]
    fn double_percent_is_a_literal_percent() {
        let l = lower("disk is %d%% full");
        assert_eq!(l.regex, r"^disk is (-?\d+)% full$");
        assert_eq!(l.spec_count, 1);
        // The literal '%' counts as a literal char.
        let re = Regex::new(&l.regex).unwrap();
        assert_eq!(&re.captures("disk is 90% full").unwrap()[1], "90");
    }

    #[test]
    fn parses_width_precision_flags_and_length() {
        for fmt in [
            "%-5s", "%.2f", "%03d", "%*d", "%.*s", "%02X", "%ld", "%lld", "%zu",
        ] {
            assert!(lower_format(fmt).is_ok(), "{fmt} should lower");
        }
        // A width/precision spec matches its bare form's shape.
        assert_eq!(lower("%03d").regex, r"^(-?\d+)$");
        assert_eq!(lower("%.2f").regex, r"^([-+0-9.eEpPxXaAfFnN]+)$");
    }

    #[test]
    fn parses_positional_specs() {
        let l = lower(r#"%1$s contains %2$d rows"#);
        assert_eq!(l.regex, r"^(.*?) contains (-?\d+) rows$");
        assert!(Regex::new(&l.regex).unwrap().is_match("t contains 5 rows"));
    }

    #[test]
    fn rejects_dangling_percent_and_unknown_conversion() {
        assert_eq!(lower_format("oops %"), Err(LowerError::DanglingPercent));
        assert_eq!(
            lower_format("%y is not real"),
            Err(LowerError::UnknownConversion('y'))
        );
    }

    #[test]
    fn round_trips_render_through_lowering() {
        for fmt in [
            r#"database "%s" does not exist"#,
            "%d of %d tuples",
            r#"could not open file "%s": %m"#,
            "value 0x%X out of range",
            "disk is %d%% full",
        ] {
            let rendered = render_sample(fmt).unwrap();
            let re = Regex::new(&lower(fmt).regex).unwrap();
            assert!(
                re.is_match(&rendered),
                "lowered({fmt}) must match render({fmt}) = {rendered:?}"
            );
        }
    }

    #[test]
    fn scanner_resolves_and_flags_ambiguity() {
        let jsonl = concat!(
            r#"{"api":"ereport","kind":"backend","level":"ERROR","message":{"text":"database \"%s\" does not exist"},"path":"a.c","line":1}"#,
            "\n",
            r#"{"api":"elog","kind":"backend","level":"DEBUG1","message":{"text":"%d of %d tuples"},"path":"b.c","line":2}"#,
            "\n",
            // Bare-%s catch-all: matches every line, drives ambiguity.
            r#"{"api":"elog","kind":"backend","level":"LOG","message":{"text":"%s"},"path":"c.c","line":3}"#,
            "\n",
            // No literal text — must be skipped.
            r#"{"api":"elog","kind":"backend","message":{"expr":"errmsg(buf)"},"path":"d.c","line":4}"#
        );
        let index = Index::from_jsonl(jsonl).unwrap();
        let (scanner, report) = Scanner::build(&index).unwrap();
        assert_eq!(report.total, 4);
        assert_eq!(report.no_text, 1);
        assert_eq!(report.compiled, 3);
        assert_eq!(scanner.pattern_count(), 3);
        // The bare `%s` catch-all has no literal run → always-check (the Rust
        // scanner still reports it; it is NOT excluded like the TS side).
        assert_eq!(scanner.always_check_count(), 1);

        // A specific line: the specific site outranks the bare "%s" catch-all.
        let hits = scanner.scan_line(r#"database "orders" does not exist"#);
        assert_eq!(hits.len(), 2, "specific site + catch-all both match");
        assert_eq!(hits[0].site, 0, "most-specific site ranked first");
        assert_eq!(hits[0].captures, vec!["orders".to_string()]);
        assert!(hits[0].literal_len > hits[1].literal_len);

        // The integer site plus the catch-all.
        let hits = scanner.scan_line("7 of 512 tuples");
        assert_eq!(hits[0].site, 1);
        assert_eq!(hits[0].captures, vec!["7".to_string(), "512".to_string()]);
    }

    /// Two `MatchHit` vecs are field-for-field identical (site, literal_len,
    /// captures, and order).
    fn hits_eq(a: &[MatchHit], b: &[MatchHit]) -> bool {
        a.len() == b.len()
            && a.iter().zip(b).all(|(x, y)| {
                x.site == y.site && x.literal_len == y.literal_len && x.captures == y.captures
            })
    }

    #[test]
    fn trigram_scan_line_equals_regexset_scan_line() {
        // A mix: quoted-string, repeated ints, %m, a short-literal pattern, and a
        // bare catch-all — exercising buckets AND the always-check set.
        let jsonl = concat!(
            r#"{"api":"ereport","kind":"backend","message":{"text":"database \"%s\" does not exist"},"path":"a.c","line":1}"#,
            "\n",
            r#"{"api":"elog","kind":"backend","message":{"text":"%d of %d tuples"},"path":"b.c","line":2}"#,
            "\n",
            r#"{"api":"elog","kind":"backend","message":{"text":"could not open file \"%s\": %m"},"path":"c.c","line":3}"#,
            "\n",
            // Short literal run (<3 chars) → always-check, not a trigram bucket.
            r#"{"api":"elog","kind":"backend","message":{"text":"a%db"},"path":"d.c","line":4}"#,
            "\n",
            // Bare catch-all → always-check.
            r#"{"api":"elog","kind":"backend","message":{"text":"%s"},"path":"e.c","line":5}"#
        );
        let index = Index::from_jsonl(jsonl).unwrap();
        let (scanner, _) = Scanner::build(&index).unwrap();

        let lines = [
            r#"database "orders" does not exist"#,
            "7 of 512 tuples",
            r#"could not open file "pg_wal/1": No such file or directory"#,
            "a5b",
            "totally unrelated line",
            "",
            "DATABASE \"X\" DOES NOT EXIST", // case: only the catch-all matches
        ];
        for line in lines {
            let tri = scanner.scan_line(line);
            let rs = scanner.scan_line_regexset(line);
            assert!(
                hits_eq(&tri, &rs),
                "trigram vs regexset differ on {line:?}:\n  trigram={tri:?}\n  regexset={rs:?}"
            );
        }
    }

    #[test]
    fn scan_line_spans_reconstructs_scan_line() {
        // Same corpus as the trigram/regexset cross-check: buckets + always-check,
        // quoted strings, repeated ints, %m, a short-literal, a bare catch-all.
        let jsonl = concat!(
            r#"{"api":"ereport","kind":"backend","message":{"text":"database \"%s\" does not exist"},"path":"a.c","line":1}"#,
            "\n",
            r#"{"api":"elog","kind":"backend","message":{"text":"%d of %d tuples"},"path":"b.c","line":2}"#,
            "\n",
            r#"{"api":"elog","kind":"backend","message":{"text":"could not open file \"%s\": %m"},"path":"c.c","line":3}"#,
            "\n",
            r#"{"api":"elog","kind":"backend","message":{"text":"a%db"},"path":"d.c","line":4}"#,
            "\n",
            r#"{"api":"elog","kind":"backend","message":{"text":"%s"},"path":"e.c","line":5}"#
        );
        let index = Index::from_jsonl(jsonl).unwrap();
        let (scanner, _) = Scanner::build(&index).unwrap();

        let lines = [
            r#"database "orders" does not exist"#,
            "7 of 512 tuples",
            r#"could not open file "pg_wal/1": No such file or directory"#,
            "a5b",
            "totally unrelated line",
            "",
        ];
        for line in lines {
            let hits = scanner.scan_line(line);
            let spans = scanner.scan_line_spans(line);
            assert_eq!(hits.len(), spans.len(), "hit count differs on {line:?}");
            for (h, s) in hits.iter().zip(&spans) {
                assert_eq!(h.site, s.site);
                assert_eq!(h.literal_len, s.literal_len);
                assert_eq!(h.captures.len(), s.captures.len());
                // Slicing the line by each span must reproduce the owned capture
                // string exactly (NO_SPAN ⇒ "").
                let reconstructed: Vec<String> = s
                    .captures
                    .iter()
                    .map(|&(start, end)| {
                        if start == NO_SPAN {
                            String::new()
                        } else {
                            line[start..end].to_string()
                        }
                    })
                    .collect();
                assert_eq!(&reconstructed, &h.captures, "captures differ on {line:?}");
            }
        }
    }
}
