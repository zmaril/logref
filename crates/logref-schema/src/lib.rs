//! logref-schema — logref's fluessig op surface, authored with the `fluessig`
//! **Rust derive front end**. Phase 1 exposes ONE op: `Scan::lower_format`, the
//! format-string → anchored-regex lowering that powers the log-line resolver.
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
}

// ═════════════════════════════════════════════════════════════════════════════
// The exporter — prints catalog.json / api.json for fluessig-gen.
// ═════════════════════════════════════════════════════════════════════════════

catalog! {
    name: "logref.scan",
    version: "0",
    entities: [],
    records: [Lowered],
    api: [Scan],
}
