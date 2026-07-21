// Build-time scan index for the Scan surface. For every reference page we
// lower its frontmatter `message` format string through the REAL Rust lowering
// (`lower_format` in crates/logref-core, compiled to wasm and run under Bun —
// the same code the browser scanner executes) and keep a compact record per
// scannable page: slug, raw message, level, and capture-group provenance.
// build.ts writes the collected records to dist/scan-index.json; the scan page
// fetches it, rebuilds the site JSONL, and constructs the wasm `Scanner` from
// it client-side. The log line never leaves the browser.

import type { MessageDoc } from "./frontmatter.ts";
import type { ScanIndexFile, ScanSite } from "./wasmScanner.ts";

/** The lowering surface this builder needs from the wasm module. */
export type LowerFn = (fmt: string) => { literalLen: number; groups: string[] };

/** Tally of what happened while lowering the catalog. */
export interface PatternReport {
  total: number;
  /** Pages whose `message` lowering failed (dangling `%` / unknown conversion). */
  lowerFailed: number;
  /** Scannable pages emitted to the index. */
  compiled: number;
  /** Bare catch-alls (no literal anchor) — counted, then held out entirely. */
  catchAlls: number;
}

/**
 * Lower an entire catalog of pages into the scan index + a build report.
 *
 * A page that cannot be lowered still gets its reference page — it just isn't
 * scannable, so it is left out of the index. A pattern with no literal
 * characters is a bare catch-all (`%s` → `^(.*?)$`): it matches every line and
 * resolves nothing, so it is also left out (the strongest form of the down-
 * ranking the Rust scanner's `literal_len` sort applies), but tallied so the
 * page can report how many were held back.
 */
export function buildScanIndex(
  docs: Iterable<MessageDoc>,
  lowerFormat: LowerFn,
): { index: ScanIndexFile; report: PatternReport } {
  const withScore: (ScanSite & { literalLen: number })[] = [];
  const report: PatternReport = {
    total: 0,
    lowerFailed: 0,
    compiled: 0,
    catchAlls: 0,
  };
  for (const doc of docs) {
    report.total++;
    let lowered: ReturnType<LowerFn>;
    try {
      lowered = lowerFormat(doc.message);
    } catch {
      report.lowerFailed++;
      continue;
    }
    if (lowered.literalLen === 0) {
      report.catchAlls++;
      continue;
    }
    withScore.push({
      slug: doc.slug,
      message: doc.message,
      level: doc.level,
      groups: lowered.groups,
      literalLen: lowered.literalLen,
    });
    report.compiled++;
  }
  // Most-specific first keeps the JSON stable and puts useful anchors early.
  withScore.sort(
    (a, b) => b.literalLen - a.literalLen || a.slug.localeCompare(b.slug),
  );
  const sites: ScanSite[] = withScore.map(
    ({ slug, message, level, groups }) => ({ slug, message, level, groups }),
  );
  return { index: { sites, catchAlls: report.catchAlls }, report };
}
