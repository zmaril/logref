#!/usr/bin/env bash
# Regenerate every artifact derived from logref's fluessig op surface: the
# committed schema/catalog.json + schema/api.json, and the wasm-bindgen binding
# (crates/logref-wasm/src/binding.rs).
#
# logref's schema is authored as Rust derives in crates/logref-schema (the
# fluessig Rust-derive front end) — there is no TypeSpec or Node in this chain.
#
# fluessig is located via $FLUESSIG_DIR:
#   - locally: a sibling checkout (defaults to ../fluessig next to this repo).
#   - in CI:   a pinned clone, exported as FLUESSIG_DIR.
#
# The chain: crates/logref-schema --(cargo run emit bins)--> schema/{catalog,api}.json
#            schema/catalog.json --(fluessig-gen --wasm)--> crates/logref-wasm/src/binding.rs
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FLUESSIG_DIR="${FLUESSIG_DIR:-$(cd "$REPO/../fluessig" 2>/dev/null && pwd || true)}"

if [ -z "${FLUESSIG_DIR:-}" ] || [ ! -f "$FLUESSIG_DIR/Cargo.toml" ]; then
  echo "error: fluessig not found. Set FLUESSIG_DIR to a fluessig checkout" >&2
  echo "       (git clone https://github.com/zmaril/fluessig), or place one at ../fluessig." >&2
  exit 1
fi

# 1. crates/logref-schema (the derive front end) -> catalog.json + api.json.
#    The schema crate is its own single-crate workspace; it reaches the fluessig
#    derive crates through a gitignored `fluessig/` symlink → $FLUESSIG_DIR.
SCHEMA="$REPO/crates/logref-schema"
ln -sfn "$FLUESSIG_DIR" "$SCHEMA/fluessig"
cargo run -q --manifest-path "$SCHEMA/Cargo.toml" --bin fluessig-emit \
  > "$REPO/schema/catalog.json"
cargo run -q --manifest-path "$SCHEMA/Cargo.toml" --bin fluessig-emit-api \
  > "$REPO/schema/api.json"

# 2. catalog.json + api.json -> the committed wasm-bindgen binding.
#    fluessig-gen wants a positional <out> for the schema_gen.rs (DDL) layer even
#    when we only want the wasm binding; send it to a scratch file we discard.
SCRATCH="$(mktemp)"
trap 'rm -f "$SCRATCH"' EXIT
cargo run -q --manifest-path "$FLUESSIG_DIR/Cargo.toml" --bin fluessig-gen -- \
  "$REPO/schema/catalog.json" "$SCRATCH" \
  --api "$REPO/schema/api.json" \
  --wasm "$REPO/crates/logref-wasm/src/binding.rs"
