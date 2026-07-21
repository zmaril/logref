// Parity tests pinning the WASM scanner path to the behavior the retired
// hand-ported TS mirrors had. The lowering expectations are ported from the
// retired lower.test.ts (they mirror the Rust unit tests in
// crates/logref-core/src/scan.rs) and now run against the REAL Rust
// `lower_format` compiled to wasm; the scanning expectations are ported from
// the retired scanner.test.ts and run against the wasm `Scanner` through the
// same packed pipeline the scan page uses (strip → scanBatchPacked → decode →
// catch-all suppression → spec labeling).

import { expect, test } from "bun:test";
import { buildScanIndex } from "./patterns.ts";
import { loadWasm } from "./wasmHost.ts";
import { type ScanSite, scanLines, sitesToJsonl } from "./wasmScanner.ts";

const { Scanner, lowerFormat, renderSample } = await loadWasm();

// ── lowering: ported from lower.test.ts ──

test("escapes literals and lowers string spec", () => {
  const l = lowerFormat('database "%s" does not exist');
  expect(l.regex).toBe('^database "(.*?)" does not exist$');
  expect(l.specCount).toBe(1);
  expect(l.groups).toEqual(["s"]);
  expect(l.literals).toEqual(['database "', '" does not exist']);
  const caps = new RegExp(l.regex).exec('database "orders" does not exist');
  expect(caps?.[1]).toBe("orders");
});

test("bare string spec matches anything", () => {
  const l = lowerFormat("%s");
  expect(l.regex).toBe("^(.*?)$");
  expect(l.literalLen).toBe(0);
  expect(l.literals).toEqual([]);
});

test("lowers integers and repeated specs", () => {
  const l = lowerFormat("%d of %d tuples");
  expect(l.regex).toBe("^(-?\\d+) of (-?\\d+) tuples$");
  expect(l.groups).toEqual(["d", "d"]);
});

test("lowers percent-m and quoted string", () => {
  const l = lowerFormat('could not open file "%s": %m');
  expect(l.regex).toBe('^could not open file "(.*?)": (.+?)$');
  expect(l.groups).toEqual(["s", "m"]);
});

test("double percent is a literal percent", () => {
  const l = lowerFormat("disk is %d%% full");
  expect(l.regex).toBe("^disk is (-?\\d+)% full$");
  expect(l.specCount).toBe(1);
  expect(l.literals).toEqual(["disk is ", "% full"]);
});

test("parses width, precision, flags and length", () => {
  for (const fmt of [
    "%-5s",
    "%.2f",
    "%03d",
    "%*d",
    "%.*s",
    "%02X",
    "%ld",
    "%lld",
    "%zu",
  ]) {
    expect(() => lowerFormat(fmt)).not.toThrow();
  }
  expect(lowerFormat("%03d").regex).toBe("^(-?\\d+)$");
  expect(lowerFormat("%.2f").regex).toBe("^([-+0-9.eEpPxXaAfFnN]+)$");
});

test("parses positional specs", () => {
  const l = lowerFormat("%1$s contains %2$d rows");
  expect(l.regex).toBe("^(.*?) contains (-?\\d+) rows$");
});

test("rejects dangling percent and unknown conversion", () => {
  expect(() => lowerFormat("oops %")).toThrow("dangling");
  expect(() => lowerFormat("%y is not real")).toThrow(
    "unknown conversion specifier '%y'",
  );
});

test("round-trips render through lowering", () => {
  for (const fmt of [
    'database "%s" does not exist',
    "%d of %d tuples",
    'could not open file "%s": %m',
    "value 0x%X out of range",
    "disk is %d%% full",
  ]) {
    const rendered = renderSample(fmt);
    const re = new RegExp(lowerFormat(fmt).regex);
    expect(re.test(rendered)).toBe(true);
  }
});

test("hex, octal, pointer and char specs lower like Rust", () => {
  expect(lowerFormat("value 0x%X out of range").regex).toBe(
    "^value 0x([0-9a-fA-F]+) out of range$",
  );
  expect(lowerFormat("mode %o").regex).toBe("^mode ([0-7]+)$");
  expect(lowerFormat("at %p").regex).toBe("^at (0x[0-9a-fA-F]+|\\(nil\\))$");
  expect(lowerFormat("char %c").regex).toBe("^char (.)$");
  // %n writes nothing: no group, no literal boundary.
  const n = lowerFormat("count%n done");
  expect(n.regex).toBe("^count done$");
  expect(n.specCount).toBe(0);
  expect(n.literals).toEqual(["count done"]);
});

// ── scanning: ported from scanner.test.ts, over the packed wasm pipeline ──

function site(slug: string, message: string, level: string[]): ScanSite {
  return { slug, message, level, groups: lowerFormat(message).groups };
}

// The retired ScanIndex's catalog: two real sites + a bare catch-all. The
// catch-all is excluded from the shipped index at BUILD time now, so the
// runtime suppression in scanLines is exercised separately below.
const SITES: ScanSite[] = [
  site("db-not-exist", 'database "%s" does not exist', ["FATAL"]),
  site("n-of-m-tuples", "%d of %d tuples", ["DEBUG1"]),
];
const scanner = new Scanner(sitesToJsonl(SITES));

const scanOne = (line: string) => scanLines(scanner, SITES, [line])[0]!;

test("resolves a specific line", () => {
  const r = scanOne('database "orders" does not exist');
  expect(r.hits).toHaveLength(1);
  expect(r.hits[0]!.site.slug).toBe("db-not-exist");
  expect(r.hits[0]!.captures).toEqual([{ spec: "%s", value: "orders" }]);
});

test("extracts multiple captures with their specs", () => {
  const r = scanOne("7 of 512 tuples");
  expect(r.hits[0]!.site.slug).toBe("n-of-m-tuples");
  expect(r.hits[0]!.captures).toEqual([
    { spec: "%d", value: "7" },
    { spec: "%d", value: "512" },
  ]);
});

test("a line with no specific pattern is unmatched", () => {
  const r = scanOne("something with no catalog pattern zzz");
  expect(r.hits).toHaveLength(0);
});

test("scanLine strips then matches", () => {
  const r = scanOne('FATAL:  database "shop" does not exist');
  expect(r.detectedLevel).toBe("FATAL");
  expect(r.core).toBe('database "shop" does not exist');
  expect(r.hits[0]!.site.slug).toBe("db-not-exist");
  expect(r.hits[0]!.captures[0]!.value).toBe("shop");
});

test("a bare catch-all in the index is suppressed from results", () => {
  // Ship the catch-all anyway (belt and braces — buildScanIndex holds it back
  // at build time) and prove the runtime layer still drops its hits.
  const withCatchAll = [...SITES, site("bare", "%s", ["LOG"])];
  const s = new Scanner(sitesToJsonl(withCatchAll));
  const r = scanLines(s, withCatchAll, ["totally unrelated line"])[0]!;
  expect(r.hits).toHaveLength(0);
  const specific = scanLines(s, withCatchAll, [
    'database "orders" does not exist',
  ])[0]!;
  expect(specific.hits).toHaveLength(1);
  expect(specific.hits[0]!.site.slug).toBe("db-not-exist");
});

test("non-ASCII captures reconstruct exactly through the packed boundary", () => {
  const uniSites = [site("uni", 'héllo "%s" wörld', ["LOG"])];
  const s = new Scanner(sitesToJsonl(uniSites));
  const r = scanLines(s, uniSites, ['héllo "wídgét 字" wörld'])[0]!;
  expect(r.hits).toHaveLength(1);
  expect(r.hits[0]!.captures).toEqual([{ spec: "%s", value: "wídgét 字" }]);
});

// ── the build-time index over the real lowering ──

test("buildScanIndex lowers through Rust, holds back catch-alls, sorts by specificity", () => {
  const doc = (slug: string, message: string) => ({
    slug,
    message,
    level: ["ERROR"],
    passthrough: false,
    api: [],
    levelRuntimeChosen: false,
    sqlstate: [],
    callSites: [],
    reproduced: false,
    body: "",
  });
  const { index, report } = buildScanIndex(
    [
      doc("short", "a%db"),
      doc("bare", "%s"),
      doc("long", 'database "%s" does not exist'),
      doc("broken", "oops %"),
    ],
    lowerFormat,
  );
  expect(report).toEqual({
    total: 4,
    lowerFailed: 1,
    compiled: 2,
    catchAlls: 1,
  });
  expect(index.catchAlls).toBe(1);
  expect(index.sites.map((s) => s.slug)).toEqual(["long", "short"]);
  expect(index.sites[0]!.groups).toEqual(["s"]);
});
