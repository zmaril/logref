// Static site generator for the LogRef reference. Reads every markdown page
// under reference/messages/, parses its frontmatter + body, and emits a static
// bundle into dist/: one HTML page per message, the search landing page, a JSON
// index of {slug, message, level, sqlstate} for the client search, and the
// stylesheet. Globs the directory, so it scales from the 33 pilot pages to the
// full ~9,000-message catalog with no code change.

import { mkdir, rm } from "node:fs/promises";
import { dirname, join } from "node:path";
import { parseFrontmatter } from "./frontmatter.ts";
import { indexPage, messagePage } from "./render.ts";
import type { MessageEntry } from "./search.ts";

const here = dirname(new URL(import.meta.url).pathname);
const root = join(here, "..");
const messagesDir = join(root, "reference", "messages");
const dist = join(root, "dist");
const generated = join(here, "generated");

async function write(path: string, content: string): Promise<void> {
  await mkdir(dirname(path), { recursive: true });
  await Bun.write(path, content);
}

async function main(): Promise<void> {
  const started = performance.now();
  await rm(dist, { recursive: true, force: true });

  const glob = new Bun.Glob("*.md");
  const entries: MessageEntry[] = [];
  let pages = 0;

  for await (const file of glob.scan({ cwd: messagesDir })) {
    const raw = await Bun.file(join(messagesDir, file)).text();
    const doc = parseFrontmatter(raw);
    await write(join(dist, "messages", `${doc.slug}.html`), messagePage(doc));
    entries.push({
      slug: doc.slug,
      message: doc.message,
      level: doc.level,
      sqlstate: [
        ...new Set(doc.sqlstate.map((s) => s.code).filter((c) => c !== "")),
      ],
    });
    pages++;
  }

  // Stable ordering: alphabetical by message text.
  entries.sort((a, b) => a.message.localeCompare(b.message));

  // The client search index is inlined into the bundle (via this JSON import in
  // index.ts) so search works from pure static files, no fetch required.
  await write(join(generated, "messages.json"), JSON.stringify(entries));
  await write(join(dist, "index.json"), JSON.stringify(entries));
  await write(join(dist, "index.html"), indexPage(entries));

  const css = await Bun.file(join(here, "style.css")).text();
  await write(join(dist, "style.css"), css);

  const ms = (performance.now() - started).toFixed(0);
  console.log(`built ${pages} message pages + index in ${ms}ms → dist/`);
}

await main();
