# Browser benchmark — the specialized WASM matcher vs the paths it replaced

A standalone demo (NOT part of the site build) that measures the wasm `Scanner`'s
in-browser throughput: the **specialized printf matcher** over the packed
`Int32Array` boundary (`scanBatchPacked` + JS decode — the path the production
scan page ships) against the **previous trigram+`regex` wasm path**
(`scanBatchPackedTrigram`) and the serde-marshalled nested `scanBatch`, all
inside the same wasm build — plus a per-line cross-check that all paths return
identical results.

It builds the scanner once from a catalog, renders ~20,000 log lines (the
site's `MAX_LINES`) via the wasm `renderSample`, and times each path with
`performance.now()` — at two catalog scales:

- **Large (production scale):** 4,000 patterns synthesized from the 48 real
  pg-catalog sites (`gen-catalog.ts`) — the scale of the site's reference index.
- **Small:** the raw 48-site `pg-catalog-sample.jsonl`.

## Run

```sh
# from the repo root — needs: cargo + wasm32-unknown-unknown target, wasm-bindgen,
# bun, and Playwright's Chromium (the CLAUDE.md headless recipe).
SIMD=1 bash crates/logref-wasm/bench/build.sh   # build the (gitignored) artifacts
bun  crates/logref-wasm/bench/drive.ts           # serve + drive headless Chromium → scratch-bench.png
# or open crates/logref-wasm/bench/index.html via any static server to view live.
```

## Headline (Chromium 141, this container, simd128, 4k patterns, N=20k)

| path | lines/sec |
| --- | --- |
| specialized WASM (`scanBatchPacked` + JS decode) | ~1.10M |
| specialized WASM (`scanBatch`, nested serde) | ~680k |
| previous trigram+`regex` WASM (packed) | ~95k |
| hand-tuned TS `ScanIndex` (retired with the WASM swap) | ~110k |

Scanner build at 4k patterns: ~50–85 ms (used to be ~1.3 s before the oracle-side
`Regex`/`RegexSet` compilation in `logref-core` became lazy). The historical
TS-mirror comparison lived in this harness until the mirror was retired; its
numbers are kept in the table above for the record. Numbers vary by machine;
re-run to reproduce.

## Files (source, committed)

- `index.html` — the benchmark page (imports the wasm web glue).
- `gen-catalog.ts` — synthesizes the large production-scale catalog from the real sites.
- `build.sh` — builds the gitignored runtime artifacts.
- `drive.ts` — serves the dir + drives headless Chromium, writes `scratch-bench.png`.
