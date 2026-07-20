//! Hand-written core seam: implement the generated `ScanCore` trait over
//! `logref-core`. The generated `binding.rs` calls
//! `<crate::core_impl::ScanImpl as ScanCore>::lower_format`; everything language-
//! specific (serde marshalling, the thrown-`JsValue` error channel) lives in the
//! generated code, so this file only bridges logref-core's types to the binding
//! DTOs.

use crate::binding::{Lowered, ScanCore};

/// The engine handle for the stateless `Scan` interface. Unit struct — the ops
/// are associated functions (no per-instance state).
pub struct ScanImpl;

impl ScanCore for ScanImpl {
    fn lower_format(fmt: String) -> anyhow::Result<Lowered> {
        // logref_core::lower_format(&str) -> Result<logref_core::Lowered, LowerError>.
        // Map the core error to anyhow (the wasm backend renders its Display text
        // into the thrown JsValue) and the core DTO to the generated one.
        let core = logref_core::lower_format(&fmt).map_err(|e| anyhow::anyhow!(e.to_string()))?;
        Ok(Lowered {
            regex: core.regex,
            // core counts are usize; the binding DTO is i32 (a JS number).
            literal_len: core.literal_len as i32,
            spec_count: core.spec_count as i32,
        })
    }
}
