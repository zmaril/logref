# site

The LogRef website: search and per-message reference pages, served as a static
[Bun](https://bun.sh) build. It loads the log-site inventory produced by the
Rust core (`crates/logref-core`) and lets a user resolve a pasted log line to
the source site it came from.

`bun run build` is a static site generator: `src/build.ts` globs every markdown
page under `reference/messages/`, parses its frontmatter and body
(`src/frontmatter.ts`), renders it to HTML (`src/markdown.ts`, `src/render.ts`),
and writes a self-contained bundle into `dist/` — one page per message, a search
landing page, a JSON index, and the stylesheet. The landing page's search box
(`src/index.ts`) filters that index in the browser with the substring matcher in
`src/search.ts`. Because it globs the directory, the same generator scales from
the pilot pages to the full catalog of roughly 9,000 messages with no code
change.

The **Scan** page runs the REAL Rust scanner (`crates/logref-core`) compiled to
WebAssembly (`crates/logref-wasm`, wasm-bindgen `--target web`) — there is no
hand-ported JS matcher. `src/build.ts` lowers every page's format string through
the same wasm module (under Bun) into `dist/scan-index.json`, and the page
(`src/scan.ts`) builds the wasm `Scanner` from it client-side, scans via the
packed `Int32Array` path (`src/packed.ts` decodes it), and layers the two
site-level presentation choices on top (`src/wasmScanner.ts`): log-prefix
stripping (`src/prefix.ts`) and bare-catch-all suppression. Matching runs
entirely in the browser — the pasted log never leaves the machine.

## Develop

```sh
bun run build:wasm  # compile the wasm scanner into src/wasm/ (gitignored) —
                    # needs cargo, the wasm32-unknown-unknown target, and a
                    # wasm-bindgen CLI matching Cargo.lock; rerun after any
                    # crates/logref-core or crates/logref-wasm change
bun run test        # unit tests (bun test) — needs src/wasm/ built
bun run build       # generate the static bundle into dist/ — needs src/wasm/
bun run dev         # generate, then rebuild the client bundle on change
```

No third-party JS dependencies, so there is nothing to install beyond the Rust
toolchain for the wasm step. To preview the built site locally, serve `dist/`
with any static file server, for example
`python3 -m http.server -d dist 4600`.

## Deploy

The bundle is deployed to Fly.io — built and served from a container (Bun build,
nginx serve). See [DEPLOY.md](./DEPLOY.md).
