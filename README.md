# LogRef

A searchable reference for database log and error messages — StackOverflow, but
for log lines. Every message is tied back to the exact source line that emits
it, with its severity and error code, and enriched with community references
around it.

A database's log surface is finite: every message it can print comes from a
specific call site in its source. LogRef mines those call sites into a
structured index, then serves search and one reference page per message. The
full rationale is in [notes/design.md](notes/design.md).

## Layout

- **`crates/logref-core`** — the core library: the `LogSite` model and the
  in-memory `Index`. Extraction and coverage build on these types.
- **`crates/logref-scan`** — the `scan` CLI: resolve log lines against an index.
- **`site/`** — the [Bun](https://bun.sh) website: Search and the generated
  Reference pages.
- **`snippets/`** — representative artifacts (extraction rules, sample records).

## Getting started

Build and test the Rust workspace ([rustup](https://rustup.rs) toolchain):

```sh
cargo test
```

The site uses [Bun](https://bun.sh); it has no third-party dependencies yet, so
there is nothing to install:

```sh
cd site && bun test && bun run build
```

`scripts/dev.sh` stands both up in one go.

## Usage

Resolve log lines against a log-site index with the `scan` CLI:

```sh
# how many sites the index holds
cargo run -p logref-scan -- stats --index snippets/sample-log-sites.jsonl

# resolve a log line to the source site it came from
cargo run -p logref-scan -- scan \
  --index snippets/sample-log-sites.jsonl \
  --query "could not open parent table"
```

```
could not open parent table
  postgres/contrib/amcheck/verify_common.c:127 ereport ERROR  — could not open parent table of index "%s"
```

Pass several `--query` flags, or omit them to read log lines from stdin.

## Docs

- [notes/design.md](notes/design.md) — what LogRef is and how it works.
- [snippets/](snippets/) — the extraction rules and sample records that define
  the index.

## Contributing

Issues and pull requests welcome. Commit and PR titles follow
[conventional commits](https://www.conventionalcommits.org); CI runs the Rust
and site checks plus [Straitjacket](https://github.com/zmaril/Straitjacket).

## License

[MIT](LICENSE).
