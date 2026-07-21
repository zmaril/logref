//! logref-schema — logref's fluessig op surface, authored with the `fluessig`
//! **Rust derive front end**. Two interfaces:
//!   * `Scan` — a *stateless* interface: `lower_format` (the format-string →
//!     anchored-regex lowering), projected to free functions.
//!   * `Scanner` — a `#[fluessig(ctor)]` interface: `build` constructs a handle
//!     (a `RegexSet`-backed scanner over an index), and `scan_line` / `scan_batch`
//!     / `report` are methods on it. This is the build-once/scan-many shape and
//!     projects to a wasm-bindgen HANDLE CLASS.
//!
//! This crate is the single source of truth for logref's binding op surface; the
//! emit bins (`src/bin/fluessig-emit.rs` / `fluessig-emit-api.rs`) print the
//! `catalog.json` / `api.json` that `scripts/gen.sh` feeds to `fluessig-gen`.
//!
//! To change the op surface, edit the `#[derive(Record)]` / `#[fluessig::export]`
//! items below and re-run `scripts/gen.sh`, then commit the regenerated artifacts.

use fluessig_derive::{catalog, export, Record};

/// A format string lowered to a regex, plus a couple of specificity signals.
/// Mirrors `logref_core::Lowered` (the `{regex, literal_len, spec_count}` core).
///
/// The counts are `i32` (fluessig `int32`) so they cross the wasm boundary as
/// plain JS numbers — `serde_wasm_bindgen` maps `i64` to `BigInt`, which would
/// break `===` against the TS mirror's `number` fields.
#[derive(Record)]
pub struct Lowered {
    /// The anchored regex source (`^…$`).
    pub regex: String,
    /// Count of *literal* characters (everything that is not a conversion spec's
    /// capture group) — the specificity signal used to rank competing matches.
    pub literal_len: i32,
    /// Number of conversion specs (capture groups) in the pattern.
    pub spec_count: i32,
    /// The conversion character for each capture group, in order (`["s","d"]`) —
    /// lets a consumer label each extracted value with the `%`-spec it came from.
    pub groups: Vec<String>,
    /// The maximal literal runs between conversion specs (each unescaped, `%%`
    /// folded to `%`); every one must appear verbatim in any matching line.
    pub literals: Vec<String>,
}

/// Why a format string could not be lowered. Surfaced only as the fallible op's
/// error channel (fluessig's op surface has no error type — a `Result<T, _>`
/// return just marks the op fallible; the wasm backend raises the `Display` text
/// as a thrown `JsValue`).
pub enum LowerError {
    DanglingPercent,
    UnknownConversion(char),
}

/// Stateless log-line lowering/resolution helpers. A unit struct keeps the op
/// root a *type* (the derive front end's spelling of a stateless interface —
/// mirrors entl's `Git`); its `#[fluessig::export]` ops become free functions in
/// the generated binding.
pub struct Scan;

/// Stateless log-line lowering/resolution helpers.
#[export]
impl Scan {
    /// Lower a Postgres/C `printf`-style format string into an anchored regex.
    /// Literal runs are escaped verbatim; each conversion spec becomes a capture
    /// group. Fallible: a dangling `%` or an unknown conversion is rejected.
    pub fn lower_format(fmt: &str) -> Result<Lowered, LowerError> {
        // Body is a stub — the derive reads only the signature. The real impl is
        // hand-written in crates/logref-wasm/src/core_impl.rs over logref-core.
        let _ = fmt;
        unimplemented!()
    }

    /// Render a format string with canned, plausible values — the inverse of
    /// `lower_format`, used to synthesize sample log lines. Fallible: rejected
    /// when the format contains a spec that lowering itself would reject.
    pub fn render_sample(fmt: &str) -> Result<String, LowerError> {
        let _ = fmt;
        unimplemented!()
    }
}

/// A single resolved match: the catalog site a rendered line traced back to, its
/// specificity, and the concrete values pulled from the line's variable bits.
/// Mirrors `logref_core::MatchHit`.
///
/// The counts are `i32` (fluessig `int32`), NOT `usize`/`u32` — fluessig's `ty()`
/// currently maps unsigned scalars to `String`, and `i64` would marshal to a
/// `BigInt` and break `===` against the TS mirror's `number` fields. `core_impl`
/// casts the core's `usize` counts to `i32`.
#[derive(Record)]
pub struct MatchHit {
    /// Index into the built index's sites (`Index::sites`).
    pub site: i32,
    /// Literal-char count of the matched pattern (higher = more specific).
    pub literal_len: i32,
    /// Captured group values, in order (empty string for an unmatched group).
    pub captures: Vec<String>,
}

/// What happened while building a `Scanner` over an index — every site is
/// accounted for exactly once across these buckets. Mirrors
/// `logref_core::BuildReport` (counts widened `usize` → `i32`).
#[derive(Record)]
pub struct BuildReport {
    /// Sites in the index.
    pub total: i32,
    /// Skipped: no literal `message.text` to lower (computed-only / `expr`).
    pub no_text: i32,
    /// Had text, but lowering rejected it.
    pub lower_failed: i32,
    /// Lowered, but the regex failed to compile.
    pub compile_failed: i32,
    /// Sites that produced a live pattern in the set.
    pub compiled: i32,
}

/// A `RegexSet`-backed log scanner: build once over an index, then scan many
/// lines. A `#[fluessig(ctor)]` interface — the derive front end's spelling of a
/// STATEFUL handle (mirrors entl's `Db`); the wasm backend projects it to a
/// wasm-bindgen handle class (`build` → the constructor, the rest → methods).
pub struct Scanner {
    // Hand-implemented core (in crates/logref-wasm/src/core_impl.rs); the derive
    // reads only the signatures below.
    _private: (),
}

/// A `RegexSet`-backed log scanner: build once, scan many.
#[export]
impl Scanner {
    /// Build a scanner over a JSONL index (`Index::from_jsonl` then
    /// `Scanner::build`): lower every site with a literal message, compile the
    /// patterns, and build the `RegexSet`. Fallible — a bad index or a pattern
    /// that overflows the regex budget is rejected (`regex::Error`).
    #[fluessig(ctor)]
    pub fn build(index_jsonl: &str) -> Self {
        // Body is a stub — the derive reads only the signature. Real impl in
        // crates/logref-wasm/src/core_impl.rs over logref-core.
        let _ = index_jsonl;
        unimplemented!()
    }

    /// Resolve ONE rendered log line to every catalog site whose pattern matches
    /// it, most-specific (longest literal) first. Empty ⇒ no match; more than one
    /// ⇒ the line is ambiguous.
    pub fn scan_line(&self, line: &str) -> Vec<MatchHit> {
        let _ = line;
        unimplemented!()
    }

    /// Resolve a BATCH of lines in ONE boundary crossing — the honest amortized
    /// shape for high-volume scanning. Returns one `MatchHit[]` per input line,
    /// positionally aligned with `lines`.
    pub fn scan_batch(&self, lines: Vec<String>) -> Vec<Vec<MatchHit>> {
        let _ = lines;
        unimplemented!()
    }

    /// The `BuildReport` tallied while building — how many sites were compiled,
    /// skipped (no text), or failed to lower/compile.
    pub fn report(&self) -> BuildReport {
        unimplemented!()
    }
}

// ═════════════════════════════════════════════════════════════════════════════
// The exporter — prints catalog.json / api.json for fluessig-gen.
// ═════════════════════════════════════════════════════════════════════════════

catalog! {
    name: "logref.scan",
    version: "0",
    entities: [],
    records: [Lowered, MatchHit, BuildReport],
    api: [Scan, Scanner],
}
