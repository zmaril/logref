#!/usr/bin/env bash
# Build the browser-benchmark demo's runtime artifacts (all gitignored):
#   - the wasm-bindgen WEB-target glue + .wasm (the fluessig-generated Scanner),
#   - the production TS scanner, bundled to ESM,
#   - the small (real) + large (synthetic, production-scale) catalogs.
# Then `bun crates/logref-wasm/bench/drive.ts` serves it + drives headless
# Chromium to produce scratch-bench.png. See README.md.
set -euo pipefail
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
BENCH="$REPO/crates/logref-wasm/bench"
cd "$REPO"

# 1. wasm web target → bench/ (build the cdylib, then wasm-bindgen --target web).
cargo build -p logref-wasm --target wasm32-unknown-unknown --release
wasm-bindgen --target web --out-dir "$BENCH" \
  target/wasm32-unknown-unknown/release/logref_wasm.wasm
# keep only the two files the page imports.
rm -f "$BENCH"/logref_wasm.d.ts "$BENCH"/logref_wasm_bg.wasm.d.ts

# 2. bundle the production TS scanner (site/src) to a browser ESM module.
bun build "$BENCH/site-entry.ts" --outfile "$BENCH/site-bundle.js" --format esm

# 3. the catalogs: the small real sample + the large synthetic one.
cp "$REPO/snippets/pg-catalog-sample.jsonl" "$BENCH/corpus.jsonl"
bun "$BENCH/gen-catalog.ts"

echo "built. run: bun crates/logref-wasm/bench/drive.ts"
