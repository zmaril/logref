#!/usr/bin/env bash
# Stand up the LogRef dev environment: build and test the Rust workspace and
# the Bun site, so `cargo test` and `bun test` both run. Safe to run from
# anywhere.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "building + testing the Rust workspace…"
cargo test

echo
echo "building + testing the site…"
(cd site && bun test && bun run build)

echo
echo "dev environment ready:"
echo "  cargo test                          # the core library + scan CLI"
echo "  (cd site && bun test)               # the website"
echo "  cargo run -p logref-scan -- --help  # the scan CLI"
