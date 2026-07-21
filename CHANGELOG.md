# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project aims
to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- The site's Scan page now runs the REAL Rust scanner compiled to WebAssembly
  (`crates/logref-wasm`, specialized printf matcher + packed `Int32Array`
  boundary) — ~10× the old hand-ported TS scanner's throughput at catalog scale.
  The TS mirrors (`site/src/lower.ts`, `site/src/scanner.ts`) are retired; the
  build-time pattern index is lowered through the same wasm module
  (`dist/scan-index.json` replaces `dist/patterns.json`).
- `logref-core`: `Scanner::build` no longer compiles the oracle-side
  `Regex`/`RegexSet`/trigram structures — they build lazily on first use of a
  cross-check path, cutting scanner construction from ~1.3 s to ~50–85 ms at
  4k patterns in-browser.
- `logref-wasm`: the fluessig `Lowered` DTO now carries `groups` + `literals`,
  and the surface gained a `renderSample` op.

### Added

- Rust workspace: `logref-core` (the `LogSite` model and in-memory `Index`) and
  the `logref-scan` CLI (`scan`, `stats`) that resolves log lines against an
  index.
- `site/` — a Bun website skeleton with a client-side search over the index.
- Design doc, extraction rules, and sample records under `notes/` and
  `snippets/`.
- CI (Rust + site), conventional-commit, Straitjacket, codespell, and vale
  workflows; fleet enrollment via `.housekeeping.toml`.
