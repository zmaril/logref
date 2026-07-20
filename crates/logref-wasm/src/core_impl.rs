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
        })
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
