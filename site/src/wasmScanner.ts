// The scan page's surface over the REAL Rust scanner (crates/logref-core,
// compiled to wasm via crates/logref-wasm). The wasm `Scanner` is ground truth
// and deliberately neutral: it reports every matching pattern, including bare
// `%s`-style catch-alls, and knows nothing about log prefixes. The two
// SITE-level presentation choices the old hand-ported TS scanner made are
// applied here, as a thin JS layer over the wasm results:
//
//   1. log-prefix stripping (prefix.ts) — match the bare message text and
//      report the severity found in the prefix;
//   2. catch-all suppression — a zero-literal pattern (`%s` → `^(.*?)$`)
//      matches every line and resolves nothing, so its hits are dropped
//      entirely and an empty result stays an honest "no specific message
//      matched". `literalLen === 0` is exactly the old `catchAll` flag.

import { decodePacked } from "./packed.ts";
import { stripLogPrefix } from "./prefix.ts";

/** One scannable site shipped in scan-index.json, aligned by array index with
 * the JSONL the wasm `Scanner` is built from — a wasm hit's `site` field
 * indexes this array. */
export interface ScanSite {
  /** Reference-page slug (`/messages/<slug>.html`). */
  slug: string;
  /** The raw format string (with `%` placeholders), for display. */
  message: string;
  /** Severity level(s) from the page frontmatter. */
  level: string[];
  /** The conversion char of each capture group, in order (`["s","d"]`) —
   * labels each captured value with the `%`-spec it came from. */
  groups: string[];
}

/** The shape of dist/scan-index.json. */
export interface ScanIndexFile {
  sites: ScanSite[];
  /** How many bare catch-all patterns the build held back from the index. */
  catchAlls: number;
}

/** A resolved match for one log line. */
export interface SiteHit {
  site: ScanSite;
  /** Literal-char count of the matched pattern (higher = more specific). */
  literalLen: number;
  /** Captured values in order, paired with the `%`-spec they came from. */
  captures: { spec: string; value: string }[];
}

/** The result of scanning one line. */
export interface LineResult {
  /** The original input line. */
  raw: string;
  /** The line after log-prefix stripping — what was actually matched. */
  core: string;
  /** Severity parsed from the log prefix, if any (e.g. `ERROR`). */
  detectedLevel?: string;
  /** All matching patterns, most-specific (longest literal) first. */
  hits: SiteHit[];
}

/** The one wasm `Scanner` method this layer needs — kept structural so tests
 * and the page can pass the wasm class without importing its glue here. */
export interface PackedScanner {
  scanBatchPacked(lines: string[]): Int32Array;
}

/**
 * Render the shipped sites as the JSONL index the wasm `Scanner` constructor
 * consumes (one `LogSite` object per line, in array order — so the scanner's
 * pattern/site numbering matches the `sites` array exactly). Only
 * `message.text` matters for scanning; the provenance fields carry the slug.
 */
export function sitesToJsonl(sites: readonly ScanSite[]): string {
  return sites
    .map((s, i) =>
      JSON.stringify({
        api: "site",
        kind: "unknown",
        message: { text: s.message },
        path: s.slug,
        line: i + 1,
      }),
    )
    .join("\n");
}

/**
 * Scan raw log lines: strip each line's prefix, resolve every stripped core in
 * ONE packed wasm call, and package per-line results with catch-alls
 * suppressed and captures labeled by their `%`-spec.
 */
export function scanLines(
  scanner: PackedScanner,
  sites: readonly ScanSite[],
  raws: readonly string[],
): LineResult[] {
  const stripped = raws.map((raw) => stripLogPrefix(raw));
  const cores = stripped.map((s) => s.core);
  const decoded = decodePacked(scanner.scanBatchPacked(cores), cores);
  return raws.map((raw, i) => ({
    raw,
    core: cores[i]!,
    detectedLevel: stripped[i]!.level,
    hits: decoded[i]!.filter((h) => h.literalLen > 0) // suppress bare catch-alls
      .map((h) => {
        const site = sites[h.site]!;
        return {
          site,
          literalLen: h.literalLen,
          captures: h.captures.map((value, g) => ({
            spec: `%${site.groups[g] ?? "?"}`,
            value,
          })),
        };
      }),
  }));
}
