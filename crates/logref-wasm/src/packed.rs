//! HAND-WRITTEN experiment — NOT fluessig-generated. A "packed" batch-scan path
//! that measures the ceiling of WASM scan throughput once the result-marshalling
//! tax is removed.
//!
//! The generated `Scanner::scanBatch` (see `binding.rs`) returns a nested
//! `MatchHit[][]`, which `serde_wasm_bindgen` materializes as ~75k JS
//! allocations (arrays + `{site, literalLen, captures}` objects + capture
//! strings) for a 20k-line batch — that serialization, not the compute, is what
//! makes batched WASM trail the TS scanner.
//!
//! `scanBatchPacked` instead encodes the whole batch's result into ONE flat
//! `Vec<i32>` (layout in `ScannerImpl::scan_batch_packed_buf`) and returns it as
//! a single `js_sys::Int32Array` — one bulk memory copy across the boundary. The
//! caller reconstructs `{site, literalLen, captures}` by slicing each input line
//! by the returned byte spans (it already holds the lines). See the bench in
//! `bench/index.html`.
//!
//! Productionization caveat — UTF-8 vs UTF-16 offsets: the emitted capture spans
//! are Rust **byte** offsets; JS strings index UTF-16 code units. For ASCII log
//! lines (this benchmark's corpus, and the overwhelming common case) the two
//! coincide, so slicing is exact. For lines with non-ASCII text a real feature
//! would emit UTF-16 offsets (or char offsets + a JS-side conversion). This
//! experiment keeps byte offsets to measure the honest best case.
//!
//! This lives in its own `impl Scanner` block, alongside the generated one,
//! rather than being threaded through the fluessig-generated binding — it is a
//! measurement of the ceiling, not a shipped op.

use wasm_bindgen::prelude::*;

use crate::binding::Scanner;

#[wasm_bindgen]
impl Scanner {
    /// Scan a batch of lines and return the entire result as ONE packed
    /// `Int32Array` (a single bulk copy across the wasm boundary) — the
    /// marshalling-free twin of `scanBatch`. Decode it JS-side by slicing each
    /// input line by the returned byte spans; see `scan_batch_packed_buf` for the
    /// layout and `bench/index.html` for the reconstruction helper.
    ///
    /// Marshal-IN is deliberately identical to `scanBatch` (`Vec<String>` via
    /// `serde_wasm_bindgen`), so the delta between the two isolates the
    /// result-marshalling cost.
    #[wasm_bindgen(js_name = "scanBatchPacked")]
    pub fn scan_batch_packed(
        &self,
        #[wasm_bindgen(unchecked_param_type = "string[]")] lines: JsValue,
    ) -> Result<js_sys::Int32Array, JsValue> {
        let lines: Vec<String> =
            serde_wasm_bindgen::from_value(lines).map_err(|e| JsValue::from_str(&e.to_string()))?;
        let buf = self.inner.scan_batch_packed_buf(&lines);
        Ok(js_sys::Int32Array::from(&buf[..]))
    }

    /// Marshal-IN probe: deserialize the `string[]` exactly as `scanBatchPacked`
    /// does, then return only the line count — no scan, no result buffer. Timing
    /// this against `scanBatchPacked` isolates the input-marshalling cost from the
    /// compute + output copy, so the bench can report whether marshal-IN is a
    /// meaningful fraction of the packed path.
    #[wasm_bindgen(js_name = "marshalInProbe")]
    pub fn marshal_in_probe(
        &self,
        #[wasm_bindgen(unchecked_param_type = "string[]")] lines: JsValue,
    ) -> Result<i32, JsValue> {
        let lines: Vec<String> =
            serde_wasm_bindgen::from_value(lines).map_err(|e| JsValue::from_str(&e.to_string()))?;
        Ok(lines.len() as i32)
    }
}
