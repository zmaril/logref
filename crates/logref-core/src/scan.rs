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
//! 2. **Scanning** ([`Scanner`]) resolves lines with a **specialized
//!    printf-pattern matcher** ([`SpecMatcher`]): every lowered pattern is an
//!    alternation-free anchored token sequence `lit₀ SPEC lit₁ …` over a tiny
//!    capture-class set, so instead of running regexes the scanner (a) finds
//!    candidate patterns with ONE Aho-Corasick pass over each pattern's anchor
//!    literal (position-constrained, plus an always-candidate set for
//!    zero-literal catch-alls), and (b) verifies each candidate with direct
//!    byte loops that reproduce the regex crate's leftmost-first semantics
//!    exactly — captures fall out as byte spans. Two older paths are retained:
//!    the **trigram prefilter** + per-candidate `Regex`
//!    ([`Scanner::scan_line_trigram`], the same algorithm as the hand-tuned TS
//!    `ScanIndex` in `site/src/scanner.ts`) for benchmarking, and the
//!    exhaustive [`regex::RegexSet`] path
//!    ([`Scanner::scan_line_regexset`]) as the ground-truth oracle — all three
//!    return identical results (the equivalence tests prove it).
//!
//! The two retained oracle paths need every pattern compiled as a real `Regex`
//! (plus the `RegexSet` and the trigram buckets), which is by far the most
//! expensive part of building a scanner (~1.3s for a ~4k-pattern catalog under
//! wasm). The default path needs none of it, so [`Scanner::build`] compiles
//! only the specialized matcher and the oracle side is built **lazily** on
//! first use of an oracle/trigram method (`OnceLock`) — a production consumer
//! that only calls [`Scanner::scan_line`]/[`Scanner::scan_line_spans`] never
//! pays for it. Lowered patterns are valid regexes by construction (escaped
//! literals + fixed class fragments), so deferring compilation loses no
//! build-time error reporting; see [`BuildReport::compile_failed`].
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
use std::sync::OnceLock;

use aho_corasick::AhoCorasick;
use memchr::memmem;
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

/// The capture class a conversion spec lowers to — the tiny, closed set of
/// shapes a printf-derived pattern can contain. Each variant corresponds 1:1 to
/// a [`conversion_group`] regex fragment; the specialized matcher
/// ([`Scanner::scan_line`]'s fast path) verifies each class with a direct byte
/// loop instead of a regex, reproducing the regex crate's leftmost-first
/// preference order exactly.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub(crate) enum SpecKind {
    /// `%s` → `(.*?)` — lazy any-run (no `\n`), possibly empty.
    Str,
    /// `%d`/`%i` → `(-?\d+)` — greedy digits with optional sign.
    Int,
    /// `%u` → `(\d+)`.
    Uint,
    /// `%o` → `([0-7]+)`.
    Oct,
    /// `%x`/`%X` → `([0-9a-fA-F]+)`.
    Hex,
    /// Float conversions → `([-+0-9.eEpPxXaAfFnN]+)`.
    Float,
    /// `%c` → `(.)` — exactly one char (not `\n`).
    Char,
    /// `%p` → `(0x[0-9a-fA-F]+|\(nil\))`.
    Ptr,
    /// `%m` → `(.+?)` — lazy any-run (no `\n`), at least one char.
    Errno,
}

impl SpecKind {
    /// The minimum number of BYTES this class can consume in a match — the
    /// specialized matcher's positional pruning uses these to bound where a
    /// pattern's anchor literal can sit in a line.
    fn min_bytes(self) -> usize {
        match self {
            SpecKind::Str => 0,
            SpecKind::Int
            | SpecKind::Uint
            | SpecKind::Oct
            | SpecKind::Hex
            | SpecKind::Float
            | SpecKind::Char
            | SpecKind::Errno => 1,
            // "0x" + one hex digit (the `(nil)` arm is longer).
            SpecKind::Ptr => 3,
        }
    }
}

/// One token of a lowered format string: a literal run or a conversion spec.
/// This is the interleaving [`Lowered::literals`]/[`Lowered::groups`] lose
/// (`"%s%d"` vs `"%s x %d"`), which the specialized matcher needs.
#[derive(Debug, Clone, PartialEq, Eq)]
pub(crate) enum FmtTok {
    Lit(String),
    Spec(SpecKind),
}

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
    /// The full token sequence (literal runs and specs, interleaved) — the
    /// structure `literals`/`groups` alone lose. Consumed by the scanner's
    /// specialized matcher; crate-internal so the public DTO shape is unchanged.
    pub(crate) tokens: Vec<FmtTok>,
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

/// The capture class a conversion character belongs to, or `None` for `%n`
/// (which writes nothing to the output) and `Err` for anything unrecognized.
fn conversion_kind(conv: char) -> Result<Option<SpecKind>, LowerError> {
    let kind = match conv {
        's' => SpecKind::Str,
        'd' | 'i' => SpecKind::Int,
        'u' => SpecKind::Uint,
        'o' => SpecKind::Oct,
        'x' | 'X' => SpecKind::Hex,
        'e' | 'E' | 'f' | 'F' | 'g' | 'G' | 'a' | 'A' => SpecKind::Float,
        'c' => SpecKind::Char,
        'p' => SpecKind::Ptr,
        // Postgres %m expands to strerror(errno) — arbitrary prose.
        'm' => SpecKind::Errno,
        'n' => return Ok(None),
        other => return Err(LowerError::UnknownConversion(other)),
    };
    Ok(Some(kind))
}

impl SpecKind {
    /// The regex fragment this class lowers to (the capture group emitted into
    /// [`Lowered::regex`]). The specialized matcher must agree with these
    /// byte-for-byte — `scan_line_regexset` is the oracle that proves it.
    fn regex_fragment(self) -> &'static str {
        match self {
            SpecKind::Str => "(.*?)",
            SpecKind::Int => r"(-?\d+)",
            SpecKind::Uint => r"(\d+)",
            SpecKind::Oct => r"([0-7]+)",
            SpecKind::Hex => r"([0-9a-fA-F]+)",
            SpecKind::Float => r"([-+0-9.eEpPxXaAfFnN]+)",
            SpecKind::Char => "(.)",
            SpecKind::Ptr => r"(0x[0-9a-fA-F]+|\(nil\))",
            SpecKind::Errno => "(.+?)",
        }
    }
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
    let mut tokens: Vec<FmtTok> = Vec::new();
    let mut i = 0;

    fn flush(
        literal: &mut String,
        out: &mut String,
        literals: &mut Vec<String>,
        tokens: &mut Vec<FmtTok>,
    ) {
        if !literal.is_empty() {
            out.push_str(&regex::escape(literal));
            literals.push(literal.clone());
            tokens.push(FmtTok::Lit(std::mem::take(literal)));
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
        if let Some(kind) = conversion_kind(conv)? {
            flush(&mut literal, &mut out, &mut literals, &mut tokens);
            out.push_str(kind.regex_fragment());
            spec_count += 1;
            groups.push(conv.to_string());
            tokens.push(FmtTok::Spec(kind));
        }
        i = next;
    }
    flush(&mut literal, &mut out, &mut literals, &mut tokens);
    out.push('$');
    Ok(Lowered {
        regex: out,
        literal_len,
        spec_count,
        groups,
        literals,
        tokens,
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
    /// Lowered, but the regex failed to compile. Always 0 since the oracle-side
    /// regex compilation became lazy: a lowered pattern (escaped literals +
    /// fixed class fragments) is a valid regex by construction, so nothing can
    /// fail here. The field is kept so the report shape (and its consumers)
    /// stay stable.
    pub compile_failed: usize,
    /// Sites that produced a live pattern in the set.
    pub compiled: usize,
}

/// A pattern compiled for the specialized matcher: its token sequence (literal
/// ids into [`SpecMatcher::lits`] + spec classes) and cheap-reject metadata.
struct MPat {
    toks: Vec<MTok>,
    /// Sum of every token's minimum byte width — a line shorter than this
    /// cannot match.
    min_len: usize,
    /// Number of capture groups (== spec tokens).
    spec_count: usize,
}

/// One token of a compiled pattern: a deduped literal id or a spec class.
#[derive(Clone, Copy)]
enum MTok {
    Lit(u32),
    Spec(SpecKind),
}

/// One fan-out entry of the anchor Aho-Corasick automaton: when AC pattern
/// `ac_id` occurs in a line, pattern `pat` is a candidate iff the occurrence
/// satisfies these positional constraints.
struct AnchorEntry {
    pat: u32,
    /// The anchor is the pattern's FIRST token → its occurrence must start at
    /// byte 0 (the pattern regex is `^`-anchored on it).
    exact_start: bool,
    /// Minimum bytes the tokens before the anchor can consume — an occurrence
    /// starting earlier cannot belong to this pattern.
    min_start: usize,
    /// Minimum bytes the tokens after the anchor must consume — an occurrence
    /// ending after `line.len() - min_tail` cannot belong to this pattern.
    min_tail: usize,
}

/// 256-entry membership table for the float conversion class
/// `[-+0-9.eEpPxXaAfFnN]`.
const FLOAT_CLASS: [bool; 256] = {
    let members = b"-+.0123456789eEpPxXaAfFnN";
    let mut t = [false; 256];
    let mut i = 0;
    while i < members.len() {
        t[members[i] as usize] = true;
        i += 1;
    }
    t
};

/// Byte length of the UTF-8 char starting with lead byte `b` (call only on a
/// char boundary of valid UTF-8, so 1 is the correct floor for stray values).
#[inline]
fn utf8_width(b: u8) -> usize {
    match b {
        0x00..=0x7F => 1,
        0xC0..=0xDF => 2,
        0xE0..=0xEF => 3,
        _ => 4,
    }
}

/// The purpose-built printf-pattern matcher [`Scanner::scan_line`] runs by
/// default — the replacement for "42 candidate regexes per line".
///
/// Every lowered pattern is an alternation-free anchored token sequence
/// `lit₀ SPEC lit₁ SPEC …` over the tiny [`SpecKind`] class set, so a general
/// regex engine does strictly redundant work. This matcher does two things
/// instead:
///
/// 1. **Candidates in one pass** — each pattern is anchored on ONE literal run
///    (its first literal when it starts with one — then the occurrence must sit
///    at byte 0 — otherwise its longest literal, with min-start/min-tail
///    positional pruning). One case-sensitive Aho-Corasick sweep over the line
///    finds every anchor occurrence of every pattern simultaneously. This is
///    both sharper than the lowercased trigram buckets (case-sensitive, and
///    position-constrained) and still sound: a matching line must contain every
///    literal run verbatim at a compatible position, so the true match set is
///    always a subset of the candidates. Zero-literal patterns (bare `%s`-style
///    catch-alls) are unfilterable and always candidates, as before.
/// 2. **Verification without a regex** — a candidate is confirmed by walking
///    its token sequence with direct byte loops: literals are `memcmp`s, numeric
///    classes are table lookups, and each lazy `%s`/`%m` gap jumps straight to
///    the next literal's occurrences via a precompiled SIMD `memmem` finder.
///    Backtracking follows the regex crate's leftmost-first preference order
///    exactly (lazy gaps grow, greedy classes shrink, `%p` tries the `0x` arm
///    first), so sites, ordering, and capture spans are byte-identical to
///    [`Scanner::scan_line_regexset`] — the equivalence tests prove it.
struct SpecMatcher {
    /// Deduped literal runs across all patterns (shared, e.g., message tails).
    lits: Vec<String>,
    /// A precompiled substring finder per literal (SIMD-accelerated memmem).
    finders: Vec<memmem::Finder<'static>>,
    /// Per compiled pattern, aligned with `Scanner::regexes`.
    pats: Vec<MPat>,
    /// The anchor automaton over deduped anchor literals.
    ac: AhoCorasick,
    /// Fan-out: AC pattern id → the patterns anchored on that literal.
    fanout: Vec<Vec<AnchorEntry>>,
    /// Patterns with no literal run at all — candidates for every line.
    no_lit: Vec<usize>,
}

impl SpecMatcher {
    /// Compile every pattern's token sequence and build the anchor automaton.
    fn build(per_pattern_tokens: &[Vec<FmtTok>]) -> Result<SpecMatcher, aho_corasick::BuildError> {
        let mut lits: Vec<String> = Vec::new();
        let mut lit_ids: HashMap<String, u32> = HashMap::new();
        let mut pats: Vec<MPat> = Vec::new();
        let mut no_lit: Vec<usize> = Vec::new();
        // anchor literal id → AC slot, deduped; slots hold the literal ids so
        // the automaton is built once `lits` is complete.
        let mut anchor_ids: HashMap<u32, usize> = HashMap::new();
        let mut anchor_lits: Vec<u32> = Vec::new();
        let mut fanout: Vec<Vec<AnchorEntry>> = Vec::new();

        for (pi, toks) in per_pattern_tokens.iter().enumerate() {
            let mtoks: Vec<MTok> = toks
                .iter()
                .map(|t| match t {
                    FmtTok::Lit(s) => {
                        let next = lits.len() as u32;
                        let id = *lit_ids.entry(s.clone()).or_insert_with(|| {
                            lits.push(s.clone());
                            next
                        });
                        MTok::Lit(id)
                    }
                    FmtTok::Spec(k) => MTok::Spec(*k),
                })
                .collect();
            let width = |t: &MTok| match t {
                MTok::Lit(id) => lits[*id as usize].len(),
                MTok::Spec(k) => k.min_bytes(),
            };
            let min_len: usize = mtoks.iter().map(width).sum();
            let spec_count = mtoks.iter().filter(|t| matches!(t, MTok::Spec(_))).count();

            // Anchor selection: the first token when it is a literal (exact
            // position 0), else the longest literal (ties → the earliest).
            let anchor_tok = match mtoks.first() {
                Some(MTok::Lit(_)) => Some(0),
                _ => mtoks
                    .iter()
                    .enumerate()
                    .filter_map(|(i, t)| match t {
                        MTok::Lit(id) => Some((i, lits[*id as usize].len())),
                        MTok::Spec(_) => None,
                    })
                    .max_by(|a, b| a.1.cmp(&b.1).then(b.0.cmp(&a.0)))
                    .map(|(i, _)| i),
            };
            match anchor_tok {
                None => no_lit.push(pi),
                Some(k) => {
                    let MTok::Lit(lit_id) = mtoks[k] else {
                        unreachable!("anchor token is a literal")
                    };
                    let min_start: usize = mtoks[..k].iter().map(width).sum();
                    let min_tail: usize = mtoks[k + 1..].iter().map(width).sum();
                    let slot = *anchor_ids.entry(lit_id).or_insert_with(|| {
                        anchor_lits.push(lit_id);
                        fanout.push(Vec::new());
                        anchor_lits.len() - 1
                    });
                    fanout[slot].push(AnchorEntry {
                        pat: pi as u32,
                        exact_start: k == 0,
                        min_start,
                        min_tail,
                    });
                }
            }
            pats.push(MPat {
                toks: mtoks,
                min_len,
                spec_count,
            });
        }

        let ac = AhoCorasick::new(anchor_lits.iter().map(|&id| lits[id as usize].as_bytes()))?;
        let finders = lits
            .iter()
            .map(|l| memmem::Finder::new(l.as_bytes()).into_owned())
            .collect();
        Ok(SpecMatcher {
            lits,
            finders,
            pats,
            ac,
            fanout,
            no_lit,
        })
    }

    /// Candidate pattern indices for `line`: every pattern whose anchor literal
    /// occurs at a compatible position, plus the zero-literal set — deduped and
    /// ascending (the order the RegexSet oracle verifies in).
    fn candidates(&self, line: &str) -> Vec<usize> {
        let n = line.len();
        let mut out: Vec<usize> = Vec::with_capacity(self.no_lit.len() + 8);
        out.extend_from_slice(&self.no_lit);
        for m in self.ac.find_overlapping_iter(line) {
            for e in &self.fanout[m.pattern().as_usize()] {
                if e.exact_start {
                    if m.start() != 0 {
                        continue;
                    }
                } else if m.start() < e.min_start {
                    continue;
                }
                if m.end() + e.min_tail > n {
                    continue;
                }
                out.push(e.pat as usize);
            }
        }
        out.sort_unstable();
        out.dedup();
        out
    }

    /// Verify candidate `pi` against `line`, returning each capture group's
    /// byte span on a match. Reproduces the anchored regex's leftmost-first
    /// semantics exactly (same spans, not just the same yes/no).
    fn verify(&self, pi: usize, line: &str) -> Option<Vec<(usize, usize)>> {
        let p = &self.pats[pi];
        if line.len() < p.min_len {
            return None;
        }
        // Cheap suffix reject: a pattern ending in a literal needs it at EOL.
        if let Some(MTok::Lit(id)) = p.toks.last() {
            if !line
                .as_bytes()
                .ends_with(self.lits[*id as usize].as_bytes())
            {
                return None;
            }
        }
        let mut caps = vec![(0usize, 0usize); p.spec_count];
        self.match_toks(&p.toks, line, 0, &mut caps).then_some(caps)
    }

    /// The backtracking core: match the token tail `toks` against `line[pos..]`
    /// (which must be consumed COMPLETELY — the pattern is `^…$`-anchored),
    /// filling `caps` (one slot per remaining spec token). Choice points are
    /// tried in the regex engine's preference order, so the first overall
    /// success carries the oracle's capture spans.
    fn match_toks(
        &self,
        mut toks: &[MTok],
        line: &str,
        mut pos: usize,
        mut caps: &mut [(usize, usize)],
    ) -> bool {
        let b = line.as_bytes();
        let n = b.len();
        // Literals never backtrack: consume any run of them iteratively.
        loop {
            match toks.first() {
                None => return pos == n,
                Some(MTok::Lit(id)) => {
                    let lit = self.lits[*id as usize].as_bytes();
                    if !b[pos..].starts_with(lit) {
                        return false;
                    }
                    pos += lit.len();
                    toks = &toks[1..];
                }
                Some(MTok::Spec(_)) => break,
            }
        }
        let Some((MTok::Spec(kind), rest)) = toks.split_first() else {
            unreachable!("loop exits only at a spec token")
        };
        let (cap, tail_caps) = caps.split_first_mut().expect("one cap slot per spec");
        caps = tail_caps;

        match *kind {
            SpecKind::Char => {
                // `(.)` — exactly one char, not `\n`.
                if pos >= n || b[pos] == b'\n' {
                    return false;
                }
                let end = pos + utf8_width(b[pos]);
                *cap = (pos, end);
                self.match_toks(rest, line, end, caps)
            }
            SpecKind::Int => {
                // `(-?\d+)`: `-?` greedily takes a '-', then greedy digits
                // backtrack from the longest run down to one digit. (If the '-'
                // has no digit after it, the empty `-?` alternative would need
                // '-' to be a digit — it can't — so there is nothing to retry.)
                let ds = if pos < n && b[pos] == b'-' {
                    pos + 1
                } else {
                    pos
                };
                let mut e = ds;
                while e < n && b[e].is_ascii_digit() {
                    e += 1;
                }
                while e > ds {
                    *cap = (pos, e);
                    if self.match_toks(rest, line, e, caps) {
                        return true;
                    }
                    e -= 1;
                }
                false
            }
            SpecKind::Uint | SpecKind::Oct | SpecKind::Hex | SpecKind::Float => {
                // A greedy byte class: longest run first, shrink on failure.
                let member = |c: u8| match *kind {
                    SpecKind::Uint => c.is_ascii_digit(),
                    SpecKind::Oct => (b'0'..=b'7').contains(&c),
                    SpecKind::Hex => c.is_ascii_hexdigit(),
                    _ => FLOAT_CLASS[c as usize],
                };
                let mut e = pos;
                while e < n && member(b[e]) {
                    e += 1;
                }
                while e > pos {
                    *cap = (pos, e);
                    if self.match_toks(rest, line, e, caps) {
                        return true;
                    }
                    e -= 1;
                }
                false
            }
            SpecKind::Ptr => {
                // `(0x[0-9a-fA-F]+|\(nil\))` — leftmost-first: the `0x` arm
                // (greedy hex) before the `(nil)` arm. The two arms' prefixes
                // are disjoint, so at most one can apply to a given position.
                if b[pos..].starts_with(b"0x") {
                    let hs = pos + 2;
                    let mut e = hs;
                    while e < n && b[e].is_ascii_hexdigit() {
                        e += 1;
                    }
                    while e > hs {
                        *cap = (pos, e);
                        if self.match_toks(rest, line, e, caps) {
                            return true;
                        }
                        e -= 1;
                    }
                }
                if b[pos..].starts_with(b"(nil)") {
                    *cap = (pos, pos + 5);
                    return self.match_toks(rest, line, pos + 5, caps);
                }
                false
            }
            SpecKind::Str | SpecKind::Errno => {
                // `(.*?)` / `(.+?)` — a lazy gap of non-`\n` chars: shortest
                // first, growing on failure. The gap may not cross a newline.
                let nl = memchr::memchr(b'\n', &b[pos..]).map_or(n, |i| pos + i);
                let min_one = matches!(*kind, SpecKind::Errno);
                match rest.first() {
                    None => {
                        // Final token: the gap must run to EOL ('$').
                        if nl < n || (min_one && pos == n) {
                            return false;
                        }
                        *cap = (pos, n);
                        true
                    }
                    Some(MTok::Lit(id)) => {
                        // Lazy gap before a literal ⇒ the literal's EARLIEST
                        // occurrence, then successive ones on failure — found
                        // with the precompiled memmem finder instead of
                        // char-stepping. (A valid-UTF-8 needle can only match
                        // at a char boundary, so gap lengths stay whole chars.)
                        let lit = self.lits[*id as usize].as_bytes();
                        let finder = &self.finders[*id as usize];
                        let mut from = if min_one { pos + 1 } else { pos };
                        while from + lit.len() <= n {
                            let Some(off) = finder.find(&b[from..]) else {
                                return false;
                            };
                            let ls = from + off;
                            if ls > nl {
                                // The gap would swallow a newline; `.` can't.
                                return false;
                            }
                            *cap = (pos, ls);
                            if self.match_toks(&rest[1..], line, ls + lit.len(), caps) {
                                return true;
                            }
                            from = ls + 1;
                        }
                        false
                    }
                    Some(MTok::Spec(_)) => {
                        // Adjacent specs (`%s%d`): grow the gap char by char.
                        let mut end = pos;
                        if min_one {
                            if end >= n || b[end] == b'\n' {
                                return false;
                            }
                            end += utf8_width(b[end]);
                        }
                        loop {
                            *cap = (pos, end);
                            if self.match_toks(rest, line, end, caps) {
                                return true;
                            }
                            if end >= n || b[end] == b'\n' {
                                return false;
                            }
                            end += utf8_width(b[end]);
                        }
                    }
                }
            }
        }
    }
}

/// The lazily-built oracle side of a [`Scanner`]: the compiled per-pattern
/// [`Regex`]es (capture extraction on the retained paths), the exhaustive
/// [`RegexSet`], and the trigram prefilter. Only the retained cross-check paths
/// ([`Scanner::scan_line_regexset`], [`Scanner::scan_line_trigram`], and their
/// span/diagnostic twins) need any of this, and compiling ~4k regexes is the
/// dominant build cost — so it is built on first oracle use, not in
/// [`Scanner::build`].
struct Oracle {
    set: RegexSet,
    regexes: Vec<Regex>,
    /// trigram → indices of patterns anchored on it (each in exactly one bucket).
    buckets: HashMap<String, Vec<usize>>,
    /// Patterns with no usable trigram (literal runs all <3 chars, or none) —
    /// checked against every line. Includes bare `%s`-style catch-alls.
    always_check: Vec<usize>,
}

/// A scanner over every lowered catalog pattern.
///
/// The default paths ([`Scanner::scan_line`] / [`Scanner::scan_line_spans`])
/// run the specialized printf matcher ([`SpecMatcher`]) — no regexes at all —
/// so [`Scanner::build`] compiles only that. The retained oracle/trigram paths
/// live in a lazily-built [`Oracle`] (per-pattern [`Regex`]es, the [`RegexSet`],
/// the trigram buckets): a consumer that never calls them never pays the
/// regex-compilation cost, which is what made scanner construction slow.
pub struct Scanner {
    site_idx: Vec<usize>,
    literal_len: Vec<usize>,
    /// The specialized printf-pattern matcher — the default [`Self::scan_line`]
    /// path (anchored Aho-Corasick candidates + regex-free verification).
    matcher: SpecMatcher,
    /// Each pattern's anchored regex source, retained for the lazy oracle build.
    patterns: Vec<String>,
    /// Each pattern's literal runs, retained for the lazy trigram-bucket build.
    per_pattern_literals: Vec<Vec<String>>,
    /// The oracle side, built on first use of an oracle/trigram method.
    oracle: OnceLock<Oracle>,
}

impl Scanner {
    /// Lower every site with a literal message and compile the specialized
    /// matcher. Returns the scanner and a [`BuildReport`] tallying what was
    /// lowered, skipped, or failed.
    ///
    /// The oracle side (per-pattern `Regex`es, the `RegexSet`, the trigram
    /// buckets) is NOT built here — it is compiled lazily on first use of an
    /// oracle/trigram method, so the default scan paths never pay for it. The
    /// `regex::Error` in the signature is retained for API stability; with the
    /// oracle deferred, nothing in the build itself can fail with it.
    pub fn build(index: &Index) -> Result<(Scanner, BuildReport), regex::Error> {
        let mut report = BuildReport {
            total: index.sites.len(),
            ..Default::default()
        };
        let mut patterns: Vec<String> = Vec::new();
        let mut site_idx: Vec<usize> = Vec::new();
        let mut literal_len: Vec<usize> = Vec::new();
        let mut per_pattern_literals: Vec<Vec<String>> = Vec::new();
        // Each compiled pattern's token sequence, for the specialized matcher.
        let mut per_pattern_tokens: Vec<Vec<FmtTok>> = Vec::new();

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

            patterns.push(lowered.regex);
            site_idx.push(idx);
            literal_len.push(lowered.literal_len);
            per_pattern_literals.push(lowered.literals);
            per_pattern_tokens.push(lowered.tokens);
        }
        report.compiled = patterns.len();

        // The specialized matcher. Its automaton build only fails on absurd
        // inputs (limits far beyond any catalog); the literals came out of a
        // successful lowering, so they are all sane strings.
        let matcher =
            SpecMatcher::build(&per_pattern_tokens).expect("anchor automaton build failed");

        Ok((
            Scanner {
                site_idx,
                literal_len,
                matcher,
                patterns,
                per_pattern_literals,
                oracle: OnceLock::new(),
            },
            report,
        ))
    }

    /// The lazily-built oracle side. First call compiles every pattern's
    /// `Regex`, the exhaustive `RegexSet`, and the trigram buckets; later calls
    /// return the cached build. Compilation cannot fail on real input — every
    /// pattern is `lower_format` output, valid by construction — so a failure
    /// here is a lowering bug and panics with the offending pattern.
    fn oracle(&self) -> &Oracle {
        self.oracle.get_or_init(|| {
            let regexes: Vec<Regex> = self
                .patterns
                .iter()
                .map(|p| {
                    Regex::new(p)
                        .unwrap_or_else(|e| panic!("lowered pattern failed to compile: {p:?}: {e}"))
                })
                .collect();

            // Generous limits: ~14k anchored patterns overflow the default budget.
            let set = RegexSetBuilder::new(&self.patterns)
                .size_limit(1 << 30)
                .dfa_size_limit(1 << 30)
                .build()
                .expect("lowered pattern set failed to compile");

            // Unique trigrams across each pattern's literal runs, tallied into a
            // global frequency table for rarest-anchor selection.
            let mut freq: HashMap<String, usize> = HashMap::new();
            let per_pattern: Vec<Vec<String>> = self
                .per_pattern_literals
                .iter()
                .map(|lits| {
                    let mut tris: Vec<String> = Vec::new();
                    for lit in lits {
                        push_trigrams(lit, &mut tris);
                    }
                    tris.sort_unstable();
                    tris.dedup();
                    for t in &tris {
                        *freq.entry(t.clone()).or_insert(0) += 1;
                    }
                    tris
                })
                .collect();

            // Anchor each pattern under its rarest trigram; patterns with none go
            // in the always-check set (short-literal patterns and bare catch-alls).
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

            Oracle {
                set,
                regexes,
                buckets,
                always_check,
            }
        })
    }

    /// Number of live patterns in the scanner.
    pub fn pattern_count(&self) -> usize {
        self.patterns.len()
    }

    /// Number of patterns held in the trigram path's always-check set (no
    /// usable trigram — short-literal patterns and bare `%s`-style catch-alls).
    /// Forces the lazy oracle build.
    pub fn always_check_count(&self) -> usize {
        self.oracle().always_check.len()
    }

    /// How many candidate patterns the trigram prefilter would verify for
    /// `line` — that prefilter's selectivity (a diagnostic for benchmarking;
    /// the smaller relative to `pattern_count`, the more it narrows). Forces
    /// the lazy oracle build.
    pub fn candidate_count(&self, line: &str) -> usize {
        self.candidate_indices(line).len()
    }

    /// How many candidate patterns the specialized matcher (the default
    /// [`Self::scan_line`] path) would verify for `line` — the anchored
    /// Aho-Corasick candidate step's selectivity, comparable against
    /// [`Self::candidate_count`].
    pub fn candidate_count_spec(&self, line: &str) -> usize {
        self.matcher.candidates(line).len()
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
        let oracle = self.oracle();
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
                if let Some(bucket) = oracle.buckets.get(&lower[bounds[k]..bounds[k + 3]]) {
                    candidates.extend_from_slice(bucket);
                }
            }
        }
        candidates.extend_from_slice(&oracle.always_check);
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
        let caps = self.oracle().regexes[pi].captures(line)?;
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
    /// matches it, most-specific (longest literal) first. An empty result means
    /// no site matched; more than one means the line is ambiguous.
    ///
    /// This is the **specialized matcher** path (see [`SpecMatcher`]): one
    /// anchored Aho-Corasick pass finds every candidate pattern, and each is
    /// verified with direct byte loops — no regex runs at all. The result is
    /// identical (site, literal_len, captures, order) to
    /// [`Scanner::scan_line_regexset`], the retained oracle, and to
    /// [`Scanner::scan_line_trigram`], the previous prefilter path.
    pub fn scan_line(&self, line: &str) -> Vec<MatchHit> {
        // Verify in ascending pattern-index order, then a *stable* sort by
        // descending literal_len — this reproduces the RegexSet path's ordering
        // exactly (RegexSet also yields ascending indices, ties preserved).
        let mut hits: Vec<MatchHit> = self
            .matcher
            .candidates(line)
            .into_iter()
            .filter_map(|pi| {
                self.matcher.verify(pi, line).map(|spans| MatchHit {
                    site: self.site_idx[pi],
                    literal_len: self.literal_len[pi],
                    captures: spans
                        .iter()
                        .map(|&(start, end)| line[start..end].to_string())
                        .collect(),
                })
            })
            .collect();
        hits.sort_by_key(|h| std::cmp::Reverse(h.literal_len));
        hits
    }

    /// Resolve one rendered log line via the previous **trigram prefilter**
    /// path: candidate patterns share a lowercased trigram with the line (plus
    /// the always-check set), each verified with its compiled `Regex`. Retained
    /// so benchmarks can compare it against the specialized [`Self::scan_line`]
    /// default; the results are identical.
    pub fn scan_line_trigram(&self, line: &str) -> Vec<MatchHit> {
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
        let caps = self.oracle().regexes[pi].captures(line)?;
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
        // The specialized matcher natively produces spans (its captures are
        // never unmatched-optional, so `NO_SPAN` cannot occur on this path).
        let mut hits: Vec<MatchHitSpans> = self
            .matcher
            .candidates(line)
            .into_iter()
            .filter_map(|pi| {
                self.matcher.verify(pi, line).map(|captures| MatchHitSpans {
                    site: self.site_idx[pi],
                    literal_len: self.literal_len[pi],
                    captures,
                })
            })
            .collect();
        hits.sort_by_key(|h| std::cmp::Reverse(h.literal_len));
        hits
    }

    /// The span-valued twin of [`Scanner::scan_line_trigram`] — the previous
    /// trigram + `Regex` path, kept callable so benchmarks can compare it
    /// against the specialized default. Identical results to
    /// [`Scanner::scan_line_spans`].
    pub fn scan_line_spans_trigram(&self, line: &str) -> Vec<MatchHitSpans> {
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
            .oracle()
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

    /// Adversarial oracle test for the specialized matcher: an index of edge
    /// patterns (adjacent specs, greedy-class/literal ambiguity, `%p` arms,
    /// overlapping literal occurrences, unicode, `%c` at EOL, bare catch-alls)
    /// scanned over edge lines (empty gaps, embedded newlines, near-misses).
    /// Every line must produce IDENTICAL hits on all three paths — specialized
    /// ([`Scanner::scan_line`]), trigram ([`Scanner::scan_line_trigram`]), and
    /// the regex oracle ([`Scanner::scan_line_regexset`]) — and identical
    /// capture SPANS (not just strings) on both span paths.
    #[test]
    fn specialized_matcher_equals_regex_oracle_on_adversarial_corpus() {
        let formats = [
            // Bare catch-alls: no literal at all — always candidates.
            "%s",
            "%m",
            "%d",
            "%c",
            // Adjacent specs (lazy/greedy interplay with no literal separator).
            "%s%d",
            "%s%s",
            "%d%d",
            "%s%c",
            "%c%c%c",
            // Greedy class followed by a literal that starts inside the class.
            "%d1x",
            "%x file",
            "%fe2",
            // Overlapping-occurrence backtracking for lazy gaps.
            "%saa",
            "[]%s[]",
            "%s at %s",
            // %p's two arms, mid-line.
            "ptr %p!",
            "%p%d",
            // %m (min one char) with a literal prefix.
            "err: %m",
            // Literal contains another pattern's literal.
            "xyz %s",
            "wxyz %s",
            // Short literals (the trigram path's always-check bucket).
            "a%db",
            // Unicode literals around a capture; %c at end of line.
            "héllo %s wörld",
            "grade %c",
            // Escaped percent + numeric capture.
            "disk is %d%% full",
            // Classic quoted-string shapes.
            r#"database "%s" does not exist"#,
            "%d of %d tuples",
            r#"could not open file "%s": %m"#,
        ];
        let jsonl: String = formats
            .iter()
            .enumerate()
            .map(|(i, f)| {
                serde_json::json!({
                    "api": "elog", "kind": "backend",
                    "message": {"text": f},
                    "path": "adv.c", "line": i + 1,
                })
                .to_string()
                    + "\n"
            })
            .collect();
        let index = Index::from_jsonl(&jsonl).unwrap();
        let (scanner, report) = Scanner::build(&index).unwrap();
        assert_eq!(report.compiled, formats.len());

        let lines = [
            // Empty and trivial.
            "",
            "x",
            "42",
            "-42",
            "-0",
            "421x",
            "42x",
            "1x",
            "-1x",
            // Adjacent-spec fodder.
            "abc123",
            "123",
            "abc",
            "ab",
            "aA",
            "aaa",
            "aa",
            "aaaa",
            // Greedy-class/literal ambiguity.
            "deadbeef file",
            "0 file",
            "f file",
            " file",
            "1.5e2",
            "e2",
            ".e2",
            "1e2e2",
            // Overlapping/lazy backtracking.
            "[][]",
            "[][][]",
            "[]x[]",
            "a at b at c",
            " at ",
            // %p arms.
            "ptr 0xDEAD!",
            "ptr 0xdead!",
            "ptr (nil)!",
            "ptr 0x!",
            "ptr 0xZ!",
            "ptr (nil) !",
            "0xff7",
            "(nil)42",
            "(nil)",
            // %m minimum-one-char.
            "err: ",
            "err: x",
            "err: No such file or directory",
            // Literal-contains-literal.
            "xyz hello",
            "wxyz hello",
            "xyz",
            "awxyz hello",
            // Short literals.
            "a5b",
            "a-5b",
            "ab",
            "a5",
            // Unicode: multibyte in captures, literals, and %c.
            "héllo wörld wörld",
            "héllo  wörld",
            "héllo é wörld",
            "grade A",
            "grade é",
            "grade 字",
            "grade ",
            "grade AB",
            // Embedded newline: `.` must not cross it anywhere.
            "a\nb",
            "err: a\nb",
            "héllo \n wörld",
            // Quoted-string classics, including case-mismatch near-misses.
            r#"database "orders" does not exist"#,
            r#"database "" does not exist"#,
            "DATABASE \"X\" DOES NOT EXIST",
            "7 of 512 tuples",
            "-7 of -512 tuples",
            r#"could not open file "pg_wal/1": No such file or directory"#,
            r#"could not open file "": "#,
            "disk is 90% full",
            "disk is -90% full",
            "disk is % full",
        ];

        for line in lines {
            let spec = scanner.scan_line(line);
            let tri = scanner.scan_line_trigram(line);
            let rs = scanner.scan_line_regexset(line);
            assert!(
                hits_eq(&spec, &rs),
                "specialized vs regexset differ on {line:?}:\n  spec={spec:?}\n  regexset={rs:?}"
            );
            assert!(
                hits_eq(&tri, &rs),
                "trigram vs regexset differ on {line:?}:\n  trigram={tri:?}\n  regexset={rs:?}"
            );
            // Span paths: identical spans (positions, not just the sliced text)
            // between the specialized matcher and the regex-derived spans.
            let spans_spec = scanner.scan_line_spans(line);
            let spans_re = scanner.scan_line_spans_trigram(line);
            assert_eq!(
                spans_spec.len(),
                spans_re.len(),
                "span hit count differs on {line:?}"
            );
            for (a, b) in spans_spec.iter().zip(&spans_re) {
                assert_eq!(a.site, b.site, "span site differs on {line:?}");
                assert_eq!(
                    a.captures, b.captures,
                    "capture spans differ on {line:?} (site {})",
                    a.site
                );
            }
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
