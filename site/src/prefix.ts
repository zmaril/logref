// Log-prefix stripping — a SITE-level presentation choice layered over the
// scanner, not part of the matcher itself. Postgres prefixes each line with
// `log_line_prefix` noise (`<timestamp> [pid] <user>@<db> LEVEL:  msg`) while
// the catalog stores only `msg`, so the scan page peels the prefix off before
// matching and reports the detected severity alongside the resolution.

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
 * match. We find the last `LEVEL:` marker and keep everything after it; failing
 * that, drop a leading timestamp/PID run. Returns the stripped core and the
 * detected level.
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
