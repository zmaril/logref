// The packed/trigram scan pair below is deliberately parallel (same marshalling
// both sides so the benchmark isolates the matcher delta — see the doc comments).
// straitjacket-allow-file:duplication
//! HAND-WRITTEN — NOT fluessig-generated. The "packed" batch-scan path: the
//! production scan surface of the site's Scan page (site/src/scan.ts), born as
//! the experiment that measured the ceiling of WASM scan throughput once the
//! result-marshalling tax is removed.
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
//! UTF-8 vs UTF-16 offsets: the emitted capture spans are Rust **byte**
//! offsets; JS strings index UTF-16 code units. For ASCII log lines (the
//! overwhelming common case) the two coincide, so the decoder slices the JS
//! string directly; for a line with non-ASCII text the production decoder
//! (site/src/packed.ts) round-trips through the line's UTF-8 bytes, so the
//! reconstruction is exact for every input.
//!
//! This lives in its own `impl Scanner` block, alongside the generated one,
//! rather than being threaded through the fluessig-generated binding — the
//! generated surface stays exactly what the fluessig schema describes, and this
//! deliberately low-level boundary shape stays a hand-maintained seam.

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

    /// The packed batch scan over the PREVIOUS fast path (trigram prefilter +
    /// per-candidate `Regex`), identical layout to `scanBatchPacked` — so the
    /// benchmark can compare the specialized matcher against the path it
    /// replaced inside the same wasm build, same marshalling both sides.
    #[wasm_bindgen(js_name = "scanBatchPackedTrigram")]
    pub fn scan_batch_packed_trigram(
        &self,
        #[wasm_bindgen(unchecked_param_type = "string[]")] lines: JsValue,
    ) -> Result<js_sys::Int32Array, JsValue> {
        let lines: Vec<String> =
            serde_wasm_bindgen::from_value(lines).map_err(|e| JsValue::from_str(&e.to_string()))?;
        let buf = self.inner.scan_batch_packed_trigram_buf(&lines);
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
