# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project aims
to follow [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Rust workspace: `logref-core` (the `LogSite` model and in-memory `Index`) and
  the `logref-scan` CLI (`scan`, `stats`) that resolves log lines against an
  index.
- `site/` — a Bun website skeleton with a client-side search over the index.
- Design doc, extraction rules, and sample records under `notes/` and
  `snippets/`.
- CI (Rust + site), conventional-commit, Straitjacket, codespell, and vale
  workflows; fleet enrollment via `.housekeeping.toml`.
