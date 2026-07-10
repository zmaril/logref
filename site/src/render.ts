// HTML rendering for the static reference site: the shared page shell, the
// severity badges, the structured-facts card, and the two page kinds (a message
// page and the search landing). The prose body of a message page is markdown,
// rendered by markdown.ts; everything else here is derived from the frontmatter
// facts so the same truth drives both the card and the index.

import { renderInline, renderMarkdown } from "./markdown.ts";
import type { MessageDoc } from "./frontmatter.ts";
import type { MessageEntry } from "./search.ts";

/** Severity tiers drive badge colour: hard failures, warnings, everything else. */
function severityTier(level: string): "error" | "warn" | "info" {
  if (["ERROR", "FATAL", "PANIC", "COMMERROR"].includes(level)) return "error";
  if (level === "WARNING") return "warn";
  return "info";
}

function badge(level: string): string {
  return `<span class="badge badge-${severityTier(level)}">${escapeAttr(level)}</span>`;
}

/** Minimal attribute/text escape for values interpolated outside markdown. */
function escapeAttr(text: string): string {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

/** The shared HTML document shell. `depth` sets how many `../` reach the root. */
export function layout(opts: {
  title: string;
  bodyClass: string;
  content: string;
  depth: number;
  script?: string;
}): string {
  const root = "../".repeat(opts.depth);
  const scriptTag = opts.script
    ? `\n    <script type="module" src="${root}${opts.script}"></script>`
    : "";
  return `<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${escapeAttr(opts.title)}</title>
    <link rel="stylesheet" href="${root}style.css" />
  </head>
  <body class="${opts.bodyClass}">
    <header class="site-header">
      <a class="brand" href="${root}index.html">LogRef</a>
      <span class="tagline">a reference for Postgres log &amp; error messages</span>
    </header>
    <main>
${opts.content}
    </main>${scriptTag}
  </body>
</html>
`;
}

/** The structured-facts card shown at the top of a message page. */
function factsCard(doc: MessageDoc): string {
  const rows: string[] = [];

  const severity = doc.passthrough
    ? '<span class="muted">varies by call site</span>'
    : doc.level.map(badge).join(" ") +
      (doc.levelRuntimeChosen
        ? ' <span class="muted">(chosen at runtime)</span>'
        : "");
  rows.push(fact("Severity", severity));

  if (doc.sqlstate.length > 0) {
    const codes = doc.sqlstate
      .map((s) => `<code>${escapeAttr(s.code)}</code> ${escapeAttr(s.symbol)}`)
      .join("<br />");
    rows.push(fact("SQLSTATE", codes));
  }

  rows.push(fact("Logging API", doc.api.map((a) => `<code>${escapeAttr(a)}</code>`).join(" ")));
  rows.push(fact("Call sites", `${doc.callSites.length}`));
  rows.push(
    fact(
      "Reproduced",
      doc.reproduced
        ? '<span class="repro repro-yes">✓ real example</span>'
        : '<span class="repro repro-no">illustrative only</span>',
    ),
  );

  return `<aside class="facts">${rows.join("")}</aside>`;
}

function fact(label: string, value: string): string {
  return `<div class="fact"><span class="fact-label">${label}</span><span class="fact-value">${value}</span></div>`;
}

/** Rewrite intra-reference `.md` links to the built `.html` pages. */
function rewriteRefHref(href: string): string {
  return href.replace(/\.md(#|$)/, ".html$1");
}

/** A full message page (facts card + rendered markdown body). */
export function messagePage(doc: MessageDoc): string {
  const content = `      <article class="message">
${factsCard(doc)}
${renderMarkdown(doc.body, rewriteRefHref)}
      </article>`;
  return layout({
    title: `${doc.message} — LogRef`,
    bodyClass: "page-message",
    content,
    depth: 1,
  });
}

/** One row in the server-rendered index list (progressive-enhancement base). */
export function entryRow(entry: MessageEntry): string {
  const badges = entry.level.map(badge).join(" ");
  const state =
    entry.sqlstate.length > 0
      ? ` <code class="sqlstate">${escapeAttr(entry.sqlstate.join(" "))}</code>`
      : "";
  return `<li><a href="messages/${escapeAttr(entry.slug)}.html"><span class="msg">${renderInline(entry.message)}</span></a> ${badges}${state}</li>`;
}

/** The search landing page. The client script (index.ts) filters #results. */
export function indexPage(entries: MessageEntry[]): string {
  const list = entries.map(entryRow).join("\n");
  const content = `      <p class="lede">Search ${entries.length} Postgres log and error messages by what you actually saw. Paste a log line or type any fragment.</p>
      <input id="q" type="search" placeholder="paste a log line…" autofocus autocomplete="off" />
      <p id="count" class="count">${entries.length} messages</p>
      <section id="results"><ul class="entries">${list}</ul></section>`;
  return layout({
    title: "LogRef — a reference for Postgres log messages",
    bodyClass: "page-index",
    content,
    depth: 0,
    script: "index.js",
  });
}
