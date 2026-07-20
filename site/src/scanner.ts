// The client-side log scanner: given the build-time pattern index
// (patterns.json), resolve each rendered log line back to the catalog message(s)
// whose format string could have produced it, extracting the variable bits.
//
// This mirrors the Rust `Scanner` (crates/logref-core/src/scan.rs) — same
// lowering, same specificity ranking (longest literal wins), same
// empty/ambiguous semantics — but swaps the Rust `RegexSet` for a **trigram
// prefilter**: JS has no RegexSet, and running ~4k (→ ~9k) anchored regexes on
// every log line is too slow. Instead each pattern is indexed under the rarest
// trigram of its literal runs; a line only tests patterns sharing a trigram with
// it. Because every literal run must appear verbatim in any matching line, the
// prefilter is sound (it never drops a real match). Bare catch-alls (`%s` →
// `^(.*?)$`, no literal) can't be prefiltered and would match everything, so
// they are excluded from normal matching and only reported as a flagged
// fallback — exactly the down-ranking the Rust scanner's `literal_len` sort does.

/** One entry in the build-time pattern index (patterns.json). */
export interface PatternEntry {
  /** Reference-page slug (`/messages/<slug>.html`). */
  slug: string;
  /** The raw format string (with `%` placeholders), for display. */
  message: string;
  /** Severity level(s) from the page frontmatter. */
  level: string[];
  /** The anchored regex source (`^…$`) the message lowered to. */
  regexSource: string;
  /** The conversion char of each capture group, in order (`["s","d"]`). */
  groups: string[];
  /** Literal-char count — the specificity score (higher = more specific). */
  literalLen: number;
  /** Literal runs between specs; the substrings any match must contain verbatim. */
  literals: string[];
  /** True when the pattern has no literal anchor (bare `%s`-style catch-all). */
  catchAll: boolean;
}

/** A resolved match for one log line. */
export interface MatchHit {
  pattern: PatternEntry;
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
  hits: MatchHit[];
}

/** Lowercase trigrams of a string (empty for strings shorter than 3 chars). */
function trigrams(s: string): string[] {
  const lower = s.toLowerCase();
  const out: string[] = [];
  for (let i = 0; i + 3 <= lower.length; i++) out.push(lower.slice(i, i + 3));
  return out;
}

/** Unique trigrams across all of a pattern's literal runs. */
function patternTrigrams(p: PatternEntry): string[] {
  const set = new Set<string>();
  for (const lit of p.literals) for (const t of trigrams(lit)) set.add(t);
  return [...set];
}

/**
 * Postgres severity keywords that appear in a log-line prefix (`… ERROR:  msg`).
 * Ordered longest-first only matters for the alternation; matching picks the
 * last occurrence so a message that merely mentions a level isn't fooled.
 */
const LEVELS = [
  "DEBUG5",
  "DEBUG4",
  "DEBUG3",
  "DEBUG2",
  "DEBUG1",
  "DEBUG",
  "LOG",
  "INFO",
  "NOTICE",
  "WARNING",
  "ERROR",
  "FATAL",
  "PANIC",
  "STATEMENT",
  "DETAIL",
  "HINT",
  "CONTEXT",
];
const PREFIX_RE = new RegExp(`\\b(${LEVELS.join("|")}):\\s+`, "g");

/**
 * Strip common Postgres log-prefix noise so the bare message text is left to
 * match. Postgres formats lines as `<timestamp> [pid] <user>@<db> LEVEL:  msg`
 * (log_line_prefix varies), and the catalog stores only `msg`. We find the last
 * `LEVEL:` marker and keep everything after it; failing that, drop a leading
 * timestamp/PID run. Returns the stripped core and the detected level.
 */
export function stripLogPrefix(line: string): {
  core: string;
  level?: string;
} {
  const trimmed = line.replace(/\s+$/, "");
  // Last `LEVEL:  ` marker wins — the real severity sits just before the message.
  let last: { end: number; level: string } | undefined;
  PREFIX_RE.lastIndex = 0;
  for (
    let m = PREFIX_RE.exec(trimmed);
    m !== null;
    m = PREFIX_RE.exec(trimmed)
  ) {
    last = { end: m.index + m[0].length, level: m[1]! };
  }
  if (last) {
    return { core: trimmed.slice(last.end).trim(), level: last.level };
  }
  // No severity marker: drop a leading `<timestamp> [pid]`-ish run if present.
  const noTs = trimmed.replace(
    /^\d{4}-\d{2}-\d{2}[ T][\d:.,+-]+(?:\s+\w+)?\s*(?:\[\d+\])?\s*/,
    "",
  );
  return { core: noTs.trim() };
}

/**
 * A compiled pattern index with a trigram prefilter. Build once from
 * patterns.json, then call {@link scanLine} per log line.
 */
export class ScanIndex {
  private readonly patterns: PatternEntry[];
  private readonly regexes: RegExp[];
  /** trigram → indices of patterns anchored on it (each pattern in exactly one). */
  private readonly buckets = new Map<string, number[]>();
  /** Patterns with a literal but no usable trigram (1–2 char literals). */
  private readonly shortLiteral: number[] = [];
  /** Count of bare catch-alls (no literal) held out of matching entirely. */
  private catchAlls = 0;

  constructor(patterns: PatternEntry[]) {
    this.patterns = patterns;
    this.regexes = patterns.map((p) => new RegExp(p.regexSource));

    // Global trigram frequency, so each pattern can anchor on its *rarest*
    // trigram — this keeps the buckets small and balanced (the pg_trgm trick).
    const freq = new Map<string, number>();
    const perPattern: string[][] = patterns.map((p) => {
      if (p.catchAll) return [];
      const tris = patternTrigrams(p);
      for (const t of tris) freq.set(t, (freq.get(t) ?? 0) + 1);
      return tris;
    });

    for (let i = 0; i < patterns.length; i++) {
      if (patterns[i]!.catchAll) {
        // A bare `%s`-style catch-all matches every line and resolves nothing,
        // so it is excluded from scan matching entirely (still flagged in the
        // index for Search/Reference). This is the strongest form of the Rust
        // scanner's "don't let zero-literal patterns swamp results".
        this.catchAlls++;
        continue;
      }
      const tris = perPattern[i]!;
      if (tris.length === 0) {
        // Had a literal but nothing >= 3 chars: always-check bucket.
        this.shortLiteral.push(i);
        continue;
      }
      let best = tris[0]!;
      let bestFreq = freq.get(best) ?? Infinity;
      for (const t of tris) {
        const f = freq.get(t) ?? Infinity;
        if (f < bestFreq) {
          best = t;
          bestFreq = f;
        }
      }
      const bucket = this.buckets.get(best);
      if (bucket) bucket.push(i);
      else this.buckets.set(best, [i]);
    }
  }

  /** Total patterns in the index (including the excluded catch-alls). */
  get patternCount(): number {
    return this.patterns.length;
  }

  /** Number of bare catch-all patterns excluded from matching. */
  get catchAllCount(): number {
    return this.catchAlls;
  }

  private capturesFor(idx: number, line: string): MatchHit["captures"] | null {
    const m = this.regexes[idx]!.exec(line);
    if (!m) return null;
    const groups = this.patterns[idx]!.groups;
    const captures: MatchHit["captures"] = [];
    for (let g = 0; g < groups.length; g++) {
      captures.push({ spec: `%${groups[g]}`, value: m[g + 1] ?? "" });
    }
    return captures;
  }

  /**
   * Resolve one already-stripped line to every catalog pattern that matches it,
   * most-specific (longest literal) first. Empty = nothing matched; more than
   * one = ambiguous. Bare catch-alls are excluded, so an empty result is an
   * honest "no specific message matched".
   */
  matchCore(core: string): MatchHit[] {
    // Candidate set: patterns sharing a trigram with the line, plus the small
    // always-check (short-literal) set. Deduped via a seen-set.
    const seen = new Set<number>();
    const candidates: number[] = [];
    for (const t of new Set(trigrams(core))) {
      const bucket = this.buckets.get(t);
      if (!bucket) continue;
      for (const i of bucket) {
        if (!seen.has(i)) {
          seen.add(i);
          candidates.push(i);
        }
      }
    }
    for (const i of this.shortLiteral) {
      if (!seen.has(i)) {
        seen.add(i);
        candidates.push(i);
      }
    }

    const hits: MatchHit[] = [];
    for (const i of candidates) {
      const captures = this.capturesFor(i, core);
      if (captures) hits.push({ pattern: this.patterns[i]!, captures });
    }

    hits.sort((a, b) => b.pattern.literalLen - a.pattern.literalLen);
    return hits;
  }

  /** Strip the log prefix, match, and package the per-line result. */
  scanLine(raw: string): LineResult {
    const { core, level } = stripLogPrefix(raw);
    return { raw, core, detectedLevel: level, hits: this.matchCore(core) };
  }
}
