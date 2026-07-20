// Tests for the client-side scanner: the trigram prefilter must not drop real
// matches, specificity ranking must put the most-specific site first, bare
// catch-alls must be held back as a flagged fallback, and log-prefix stripping
// must recover the bare message text. Mirrors the Rust
// `scanner_resolves_and_flags_ambiguity` test in scan.rs.

import { expect, test } from "bun:test";
import { lowerFormat } from "./lower.ts";
import { type PatternEntry, ScanIndex, stripLogPrefix } from "./scanner.ts";

function entry(slug: string, message: string, level: string[]): PatternEntry {
  const l = lowerFormat(message);
  return {
    slug,
    message,
    level,
    regexSource: l.regex,
    groups: l.groups,
    literalLen: l.literalLen,
    literals: l.literals,
    catchAll: l.literalLen === 0,
  };
}

const index = new ScanIndex([
  entry("db-not-exist", 'database "%s" does not exist', ["FATAL"]),
  entry("n-of-m-tuples", "%d of %d tuples", ["DEBUG1"]),
  entry("bare", "%s", ["LOG"]),
]);

test("resolves a specific line, excluding the bare catch-all", () => {
  const hits = index.matchCore('database "orders" does not exist');
  // The bare `%s` catch-all is excluded entirely, so only the real site matches.
  expect(hits).toHaveLength(1);
  expect(hits[0]!.pattern.slug).toBe("db-not-exist");
  expect(hits[0]!.captures).toEqual([{ spec: "%s", value: "orders" }]);
});

test("extracts multiple captures with their specs", () => {
  const hits = index.matchCore("7 of 512 tuples");
  expect(hits[0]!.pattern.slug).toBe("n-of-m-tuples");
  expect(hits[0]!.captures).toEqual([
    { spec: "%d", value: "7" },
    { spec: "%d", value: "512" },
  ]);
});

test("a line with no specific pattern is unmatched (catch-all excluded)", () => {
  const hits = index.matchCore("something with no catalog pattern zzz");
  expect(hits).toHaveLength(0);
  // The bare `%s` is counted but never matched.
  expect(index.catchAllCount).toBe(1);
});

test("trigram prefilter does not drop a real match", () => {
  // A line only reachable through the prefilter's trigram buckets.
  const hits = index.matchCore('database "long_name_here" does not exist');
  expect(hits[0]!.pattern.slug).toBe("db-not-exist");
  expect(hits[0]!.captures[0]!.value).toBe("long_name_here");
});

test("strips a full Postgres log prefix down to the bare message", () => {
  const { core, level } = stripLogPrefix(
    '2024-01-01 12:00:00.123 UTC [1234] user@db ERROR:  relation "orders" does not exist',
  );
  expect(core).toBe('relation "orders" does not exist');
  expect(level).toBe("ERROR");
});

test("strips a bare severity prefix", () => {
  const { core, level } = stripLogPrefix(
    "FATAL:  the database system is starting up",
  );
  expect(core).toBe("the database system is starting up");
  expect(level).toBe("FATAL");
});

test("scanLine strips then matches", () => {
  const r = index.scanLine('FATAL:  database "shop" does not exist');
  expect(r.detectedLevel).toBe("FATAL");
  expect(r.core).toBe('database "shop" does not exist');
  expect(r.hits[0]!.pattern.slug).toBe("db-not-exist");
  expect(r.hits[0]!.captures[0]!.value).toBe("shop");
});
