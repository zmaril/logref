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
//!    [`regex::RegexSet`] (which patterns match a line) *paired* with a parallel
//!    `Vec<Regex>` (per-hit captures — a `RegexSet` reports membership only, not
//!    groups). A line is resolved by asking the set for candidate patterns then
//!    running each candidate's `Regex::captures` to pull the variable bits out.
//!
//! [`render_sample`] is the inverse used for round-trip testing and for
//! synthesizing a sample log from the catalog: it fills each conversion spec
//! with a plausible concrete value, producing a line the lowering must match.

use regex::{Regex, RegexSet, RegexSetBuilder};

use crate::Index;

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
    if i < chars.len() && chars[i] == '*' {
        i += 1;
    } else {
        while i < chars.len() && chars[i].is_ascii_digit() {
            i += 1;
        }
    }
    // Precision: '.' then digits or '*'.
    if i < chars.len() && chars[i] == '.' {
        i += 1;
        if i < chars.len() && chars[i] == '*' {
            i += 1;
        } else {
            while i < chars.len() && chars[i].is_ascii_digit() {
                i += 1;
            }
        }
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
    let mut i = 0;

    fn flush(literal: &mut String, out: &mut String) {
        if !literal.is_empty() {
            out.push_str(&regex::escape(literal));
            literal.clear();
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
            flush(&mut literal, &mut out);
            out.push_str(group);
            spec_count += 1;
        }
        i = next;
    }
    flush(&mut literal, &mut out);
    out.push('$');
    Ok(Lowered {
        regex: out,
        literal_len,
        spec_count,
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

/// A `RegexSet` over every lowered catalog pattern, paired with a parallel
/// `Vec<Regex>` so a hit can be re-run for captures. Site provenance is kept as
/// a parallel index back into the source [`Index`].
pub struct Scanner {
    set: RegexSet,
    regexes: Vec<Regex>,
    site_idx: Vec<usize>,
    literal_len: Vec<usize>,
}

impl Scanner {
    /// Lower every site with a literal message, compile the patterns, and build
    /// the `RegexSet`. Returns the scanner and a [`BuildReport`] tallying what
    /// was lowered, skipped, or failed.
    pub fn build(index: &Index) -> Result<(Scanner, BuildReport), regex::Error> {
        let mut report = BuildReport {
            total: index.sites.len(),
            ..Default::default()
        };
        let mut patterns: Vec<String> = Vec::new();
        let mut regexes: Vec<Regex> = Vec::new();
        let mut site_idx: Vec<usize> = Vec::new();
        let mut literal_len: Vec<usize> = Vec::new();

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
            patterns.push(lowered.regex);
            regexes.push(re);
            site_idx.push(idx);
            literal_len.push(lowered.literal_len);
        }
        report.compiled = patterns.len();

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
            },
            report,
        ))
    }

    /// Number of live patterns in the set.
    pub fn pattern_count(&self) -> usize {
        self.regexes.len()
    }

    /// Resolve one rendered log line to every catalog site whose pattern
    /// matches it, most-specific (longest literal) first. An empty result means
    /// no site matched; more than one means the line is ambiguous.
    pub fn scan_line(&self, line: &str) -> Vec<MatchHit> {
        let mut hits: Vec<MatchHit> = self
            .set
            .matches(line)
            .into_iter()
            .filter_map(|pi| {
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
            })
            .collect();
        hits.sort_by(|a, b| b.literal_len.cmp(&a.literal_len));
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
}
