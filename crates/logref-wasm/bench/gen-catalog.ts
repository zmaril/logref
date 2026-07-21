// Synthesize a realistic large catalog (~4000 sites) from the 48 real pg-catalog
// sites, so the browser benchmark can measure scanner throughput at PRODUCTION
// SCALE (the site's reference index is thousands of patterns, where the ~58k
// lines/sec TS baseline lives) rather than only the tiny 48-site sample.
//
// Each real site's format text is replicated under a unique discriminating
// literal prefix (`svcR.modN: `) so the patterns stay REAL printf strings with
// real %-specs, but the catalog grows to production scale — the size at which the
// trigram-prefilter (TS) vs RegexSet (WASM) scaling actually diverges.
//
// Run from the repo root: bun crates/logref-wasm/bench/gen-catalog.ts
import { readFileSync, writeFileSync } from "node:fs";
import { join } from "node:path";

const REPO = join(import.meta.dir, "..", "..", "..");
const OUT = join(import.meta.dir, "corpus-large.jsonl");
const TARGET = 4000;

const base = readFileSync(join(REPO, "snippets/pg-catalog-sample.jsonl"), "utf8")
  .split("\n")
  .filter((l) => l.trim())
  .map((l) => JSON.parse(l));
const withText = base.filter((s) => s.message?.text);

const out: string[] = [];
let n = 0;
outer: for (let r = 0; r < 1000; r++) {
  for (const s of withText) {
    const site = JSON.parse(JSON.stringify(s));
    site.message = { text: `svc${r}.mod${n % 37}: ${s.message.text}` };
    site.line = n + 1;
    out.push(JSON.stringify(site));
    if (++n >= TARGET) break outer;
  }
}
writeFileSync(OUT, out.join("\n"));
console.log(`wrote ${out.length} synthetic sites (from ${withText.length} real templates) → ${OUT}`);
