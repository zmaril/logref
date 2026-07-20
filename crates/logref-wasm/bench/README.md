# Browser benchmark — batched WASM `Scanner` vs the hand-tuned TS `ScanIndex`

A standalone demo (NOT part of the site build) that answers: **can the
fluessig-generated wasm `Scanner` handle, called in one batched boundary
crossing (`scanBatch`), beat the production hand-tuned TypeScript scanner
(`site/src/scanner.ts`) at high volume in a real browser?**

It builds each scanner once from the same catalog, renders ~20,000 log lines
(the site's `MAX_LINES`), and times `scanBatch` (WASM) against per-line
`scanLine` (TS) with `performance.now()` — at two catalog scales:

- **Large (production scale):** 4,000 patterns synthesized from the 48 real
  pg-catalog sites (`gen-catalog.ts`) — the scale of the site's reference index,
  where the ~58k lines/sec TS baseline lives.
- **Small:** the raw 48-site `pg-catalog-sample.jsonl`.

## Run

```sh
# from the repo root — needs: cargo + wasm32-unknown-unknown target, wasm-bindgen,
# bun, and Playwright's Chromium (the CLAUDE.md headless recipe).
bash crates/logref-wasm/bench/build.sh          # build the (gitignored) artifacts
bun  crates/logref-wasm/bench/drive.ts           # serve + drive headless Chromium → scratch-bench.png
# or open crates/logref-wasm/bench/index.html via any static server to view live.
```

## Headline (Chromium 141, this container)

| catalog | batched WASM `scanBatch` | hand-tuned TS `ScanIndex` | winner |
| --- | --- | --- | --- |
| 4,000 patterns (production scale) | ~56k lines/sec (build 1816 ms) | ~122k lines/sec (build 47 ms) | **TS ~2.2×** |
| 48 patterns (tiny) | ~303k lines/sec | ~272k lines/sec | WASM ~1.1× |

**Honest read:** even batched, WASM does *not* beat the hand-tuned TS at
realistic catalog scale. The TS trigram prefilter tests only the handful of
patterns sharing a trigram with each line, while the Rust `RegexSet` runs its
combined DFA over all patterns and then `serde_wasm_bindgen` marshals 20k lines
in + a 4k-deep nested result out. Batching amortizes the *boundary crossing* (one
call, not 20k) but not the per-line matching work or the result serialization.
WASM only edges ahead on a tiny catalog where the RegexSet is small and
marshalling is the whole story. Numbers vary by machine; re-run to reproduce.

## Files (source, committed)

- `index.html` — the benchmark page (imports the wasm web glue + the bundled TS scanner).
- `site-entry.ts` — bundle entry re-exporting `ScanIndex` / `lowerFormat` / `renderSample`.
- `gen-catalog.ts` — synthesizes the large production-scale catalog from the real sites.
- `build.sh` — builds the gitignored runtime artifacts.
- `drive.ts` — serves the dir + drives headless Chromium, writes `scratch-bench.png`.
