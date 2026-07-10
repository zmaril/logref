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

## Develop

```sh
bun run test        # unit tests (bun test)
bun run build       # generate the static bundle into dist/
bun run dev         # generate, then rebuild the client bundle on change
```

No third-party dependencies, so there is nothing to install. To preview the
built site locally, serve `dist/` with any static file server, for example
`python3 -m http.server -d dist 4600`.

## Deploy

The bundle is deployed to Cloudflare Pages. See [DEPLOY.md](./DEPLOY.md).
