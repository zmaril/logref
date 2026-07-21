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
# Optionally: wasm-opt (binaryen) for the size pass below — skipped with a
# warning when missing, unless WASM_OPT_REQUIRED=1 (CI and the Dockerfile set
# it so production always ships the optimized module).
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

# Shrink the module with wasm-opt (binaryen), in place. The feature flags must
# cover everything rustc emits for wasm32-unknown-unknown — +simd128 from above
# plus the (rustc 1.87+) defaults: bulk-memory, nontrapping-fptoint, sign-ext,
# mutable-globals, multivalue, reference-types. If a toolchain bump adds a
# feature, wasm-opt fails validation naming the missing --enable-* flag.
WASM="$OUT/logref_wasm_bg.wasm"
if command -v wasm-opt >/dev/null 2>&1; then
  BEFORE="$(wc -c <"$WASM")"
  wasm-opt -O3 \
    --enable-simd --enable-bulk-memory --enable-nontrapping-float-to-int \
    --enable-sign-ext --enable-mutable-globals --enable-multivalue \
    --enable-reference-types \
    "$WASM" -o "$WASM.opt"
  mv "$WASM.opt" "$WASM"
  echo "wasm-opt ($(wasm-opt --version)): $BEFORE → $(wc -c <"$WASM") bytes"
elif [ "${WASM_OPT_REQUIRED:-0}" = "1" ]; then
  echo "error: wasm-opt not found but WASM_OPT_REQUIRED=1 — install binaryen" >&2
  exit 1
else
  echo "warning: wasm-opt (binaryen) not found — skipping the size pass; the" >&2
  echo "         module works but ships ~8% larger. To fix: install binaryen" >&2
  echo "         (apt/apk/brew install binaryen) and re-run." >&2
fi

echo "wasm scanner → $OUT ($(wc -c <"$OUT/logref_wasm_bg.wasm") bytes)"
