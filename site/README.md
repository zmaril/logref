# site

The LogRef website: search and per-message reference pages, served as a static
[Bun](https://bun.sh) build. It loads the log-site inventory produced by the
Rust core (`crates/logref-core`) and lets a user resolve a pasted log line to
the source site it came from.

This is an early skeleton — a working search box over a sample index. The full
search engine and generated reference pages land on top of `src/search.ts`.

## Develop

```sh
bun run test        # unit tests (bun test)
bun run build       # bundle to dist/
bun run dev         # build + hot-serve
```

No third-party dependencies yet, so there is nothing to install.
