#!/usr/bin/env bash
# Build the production browser scanner: compile crates/logref-wasm for
# wasm32-unknown-unknown (release, simd128 — memchr/aho-corasick have simd128
# kernels and every current evergreen browser supports it) and run wasm-bindgen
# --target web into site/src/wasm/ (gitignored):
#   logref_wasm.js       the ESM glue the site bundles into scan.js
#   logref_wasm.d.ts     its types (typecheck)
#   logref_wasm_bg.wasm  the module; site/src/build.ts copies it into dist/
#
# Needs: the wasm32-unknown-unknown target and a wasm-bindgen CLI matching the
# wasm-bindgen crate version in Cargo.lock (CI pins it; see .github/workflows).
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$REPO/site/src/wasm"

export RUSTFLAGS="${RUSTFLAGS:-} -C target-feature=+simd128"
cargo build -p logref-wasm --target wasm32-unknown-unknown --release \
  --manifest-path "$REPO/Cargo.toml"
wasm-bindgen --target web --out-dir "$OUT" \
  "$REPO/target/wasm32-unknown-unknown/release/logref_wasm.wasm"
# Keep only the three files the site consumes.
rm -f "$OUT/logref_wasm_bg.wasm.d.ts"

echo "wasm scanner → $OUT ($(wc -c <"$OUT/logref_wasm_bg.wasm") bytes)"
