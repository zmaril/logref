//! Hand-written core seam: implement the generated `ScanCore` trait over
//! `logref-core`. The generated `binding.rs` calls
//! `<crate::core_impl::ScanImpl as ScanCore>::lower_format`; everything language-
//! specific (serde marshalling, the thrown-`JsValue` error channel) lives in the
//! generated code, so this file only bridges logref-core's types to the binding
//! DTOs.

use crate::binding::{BuildReport, Lowered, MatchHit, ScanCore, ScannerCore};

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
            groups: core.groups,
            literals: core.literals,
        })
    }

    fn render_sample(fmt: String) -> anyhow::Result<String> {
        // logref_core::render_sample(&str) -> Option<String>; `None` (a spec the
        // lowering would reject) becomes the thrown error text.
        logref_core::render_sample(&fmt)
            .ok_or_else(|| anyhow::anyhow!("format string cannot be rendered"))
    }
}

/// The engine handle for the stateful `Scanner` interface. Holds the built
/// `logref_core::Scanner` (a `RegexSet` over the index's lowered patterns) plus
/// the `BuildReport` tallied while building — the `#[fluessig(ctor)]` handle-class
/// projection makes this the `inner` of the generated `Scanner` wasm class.
pub struct ScannerImpl {
    scanner: logref_core::Scanner,
    report: logref_core::BuildReport,
}

/// Bridge one core `MatchHit` (counts `usize`) to the generated DTO (`i32`).
fn hit(core: logref_core::MatchHit) -> MatchHit {
    MatchHit {
        site: core.site as i32,
        literal_len: core.literal_len as i32,
        captures: core.captures,
    }
}

impl ScannerCore for ScannerImpl {
    fn build(index_jsonl: String) -> anyhow::Result<Self> {
        // Parse the JSONL index, then build the RegexSet-backed scanner. Both the
        // JSON parse and the regex-set build are fallible; map each to anyhow so
        // the wasm backend surfaces the Display text as the thrown JsValue.
        let index = logref_core::Index::from_jsonl(&index_jsonl)
            .map_err(|e| anyhow::anyhow!(e.to_string()))?;
        let (scanner, report) =
            logref_core::Scanner::build(&index).map_err(|e| anyhow::anyhow!(e.to_string()))?;
        Ok(ScannerImpl { scanner, report })
    }

    fn scan_line(&self, line: String) -> Vec<MatchHit> {
        self.scanner.scan_line(&line).into_iter().map(hit).collect()
    }

    fn scan_batch(&self, lines: Vec<String>) -> Vec<Vec<MatchHit>> {
        // ONE boundary crossing for all lines: the batch marshals in as a single
        // JsValue and back out as a single nested list, amortizing per-line string
        // transfer across the whole batch.
        lines
            .iter()
            .map(|line| self.scanner.scan_line(line).into_iter().map(hit).collect())
            .collect()
    }

    fn report(&self) -> BuildReport {
        BuildReport {
            total: self.report.total as i32,
            no_text: self.report.no_text as i32,
            lower_failed: self.report.lower_failed as i32,
            compile_failed: self.report.compile_failed as i32,
            compiled: self.report.compiled as i32,
        }
    }
}

/// The packed scan path (the production scan surface — see `src/packed.rs`).
/// Kept on the hand-written seam because it reaches `logref_core::Scanner`'s
/// span-valued scan (`scan_line_spans`); `packed.rs` is only the thin
/// `#[wasm_bindgen]` wrapper that hands the buffer to JS as one `Int32Array`.
impl ScannerImpl {
    /// Scan every line and encode ALL hits into ONE flat `Vec<i32>` — the whole
    /// batch's result as a single contiguous buffer, so it crosses the wasm
    /// boundary as one bulk copy instead of ~75k `serde_wasm_bindgen`-built JS
    /// allocations.
    ///
    /// Self-describing layout, read back sequentially (the caller already knows
    /// `lines.len()`, so no top-level count is emitted) — per line, in order:
    ///
    /// ```text
    /// [ numHits, (site, literalLen, numCaps, (capStart, capEnd)*)* ]
    /// ```
    ///
    /// `capStart`/`capEnd` are **byte** offsets into that line; an unmatched
    /// optional group is `(-1, -1)` (reconstructs to `""`). Log lines are ~ASCII,
    /// so byte offsets coincide with the JS UTF-16 indices the caller slices with
    /// — see `packed.rs` for the productionization caveat.
    pub fn scan_batch_packed_buf(&self, lines: &[String]) -> Vec<i32> {
        Self::pack(lines, |line| self.scanner.scan_line_spans(line))
    }

    /// The trigram + `Regex` twin of [`Self::scan_batch_packed_buf`]: identical
    /// packed layout, but each line is resolved via the PREVIOUS fast path
    /// (`scan_line_spans_trigram`) instead of the specialized matcher. Kept so
    /// the browser benchmark can time old vs new inside the same wasm build.
    pub fn scan_batch_packed_trigram_buf(&self, lines: &[String]) -> Vec<i32> {
        Self::pack(lines, |line| self.scanner.scan_line_spans_trigram(line))
    }

    /// Encode one batch's span-valued hits into the packed layout documented on
    /// [`Self::scan_batch_packed_buf`], with `scan` supplying each line's hits.
    fn pack(lines: &[String], scan: impl Fn(&str) -> Vec<logref_core::MatchHitSpans>) -> Vec<i32> {
        // Rough prealloc: most lines resolve to a hit or two with a capture each.
        let mut buf: Vec<i32> = Vec::with_capacity(lines.len() * 6);
        for line in lines {
            let hits = scan(line);
            buf.push(hits.len() as i32);
            for h in &hits {
                buf.push(h.site as i32);
                buf.push(h.literal_len as i32);
                buf.push(h.captures.len() as i32);
                for &(start, end) in &h.captures {
                    if start == logref_core::NO_SPAN {
                        buf.push(-1);
                        buf.push(-1);
                    } else {
                        buf.push(start as i32);
                        buf.push(end as i32);
                    }
                }
            }
        }
        buf
    }
}
