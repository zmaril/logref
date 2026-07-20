// Build-time pattern index for the Scan surface. For every reference page we
// lower its frontmatter `message` format string to an anchored regex (via the
// shared lowering in lower.ts — the same one the Rust scanner uses) and emit a
// compact record: slug, raw message, level, regex source, capture-group
// provenance, a literal-length specificity score, and a catch-all flag. build.ts
// writes the collected records to dist/patterns.json, which the scan page fetches
// and compiles client-side. The log line never leaves the browser.

import type { MessageDoc } from "./frontmatter.ts";
import { tryLowerFormat } from "./lower.ts";
import type { PatternEntry } from "./scanner.ts";

/** Tally of what happened while lowering the catalog — mirrors the Rust `BuildReport`. */
export interface PatternReport {
  total: number;
  /** Pages whose `message` lowering failed (dangling `%` / unknown conversion). */
  lowerFailed: number;
  /** Pages whose lowered regex failed to compile. */
  compileFailed: number;
  /** Live patterns emitted to the index. */
  compiled: number;
  /** Of the compiled, how many are bare catch-alls (no literal anchor). */
  catchAlls: number;
}

/**
 * Lower one page's format string into a {@link PatternEntry}, or `null` if it
 * cannot be lowered or compiled (the page still gets its reference page — it just
 * isn't scannable). A pattern with no literal characters is a bare catch-all
 * (`%s` → `^(.*?)$`): kept, but flagged so the scanner holds it back from normal
 * matching, exactly as the Rust scanner down-ranks a zero-`literal_len` site.
 */
export function toPatternEntry(doc: MessageDoc): PatternEntry | null {
  const lowered = tryLowerFormat(doc.message);
  if (!lowered) return null;
  try {
    new RegExp(lowered.regex);
  } catch {
    return null;
  }
  return {
    slug: doc.slug,
    message: doc.message,
    level: doc.level,
    regexSource: lowered.regex,
    groups: lowered.groups,
    literalLen: lowered.literalLen,
    literals: lowered.literals,
    catchAll: lowered.literalLen === 0,
  };
}

/** Lower an entire catalog of pages into the pattern index + a build report. */
export function buildPatternIndex(docs: Iterable<MessageDoc>): {
  patterns: PatternEntry[];
  report: PatternReport;
} {
  const patterns: PatternEntry[] = [];
  const report: PatternReport = {
    total: 0,
    lowerFailed: 0,
    compileFailed: 0,
    compiled: 0,
    catchAlls: 0,
  };
  for (const doc of docs) {
    report.total++;
    const lowered = tryLowerFormat(doc.message);
    if (!lowered) {
      report.lowerFailed++;
      continue;
    }
    const entry = toPatternEntry(doc);
    if (!entry) {
      report.compileFailed++;
      continue;
    }
    patterns.push(entry);
    report.compiled++;
    if (entry.catchAll) report.catchAlls++;
  }
  // Most-specific first keeps the JSON stable and puts useful anchors early.
  patterns.sort(
    (a, b) => b.literalLen - a.literalLen || a.slug.localeCompare(b.slug),
  );
  return { patterns, report };
}
