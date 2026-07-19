// HTML rendering for the static reference site: the shared page shell, the
// severity badges, the structured-facts card, and the two page kinds (a message
// page and the search landing). The prose body of a message page is markdown,
// rendered by markdown.ts; everything else here is derived from the frontmatter
// facts so the same truth drives both the card and the index.

import type { MessageDoc } from "./frontmatter.ts";
import { escapeHtml, renderInline, renderMarkdown } from "./markdown.ts";
import type { MessageEntry } from "./search.ts";

/** Postgres SQLSTATE error classes (first two chars of a code → class name),
 * per the standard errcodes appendix. Drives the `## SQLSTATE` section's class
 * label. The pilot needs only a handful of these, but the full table is cheap
 * and keeps the generator correct as the catalog grows to all 8,988 messages. */
const SQLSTATE_CLASSES: Record<string, string> = {
  "00": "Successful Completion",
  "01": "Warning",
  "02": "No Data",
  "03": "SQL Statement Not Yet Complete",
  "08": "Connection Exception",
  "09": "Triggered Action Exception",
  "0A": "Feature Not Supported",
  "0B": "Invalid Transaction Initiation",
  "0F": "Locator Exception",
  "0L": "Invalid Grantor",
  "0P": "Invalid Role Specification",
  "0Z": "Diagnostics Exception",
  "20": "Case Not Found",
  "21": "Cardinality Violation",
  "22": "Data Exception",
  "23": "Integrity Constraint Violation",
  "24": "Invalid Cursor State",
  "25": "Invalid Transaction State",
  "26": "Invalid SQL Statement Name",
  "27": "Triggered Data Change Violation",
  "28": "Invalid Authorization Specification",
  "2B": "Dependent Privilege Descriptors Still Exist",
  "2D": "Invalid Transaction Termination",
  "2F": "SQL Routine Exception",
  "34": "Invalid Cursor Name",
  "38": "External Routine Exception",
  "39": "External Routine Invocation Exception",
  "3B": "Savepoint Exception",
  "3D": "Invalid Catalog Name",
  "3F": "Invalid Schema Name",
  "40": "Transaction Rollback",
  "42": "Syntax Error or Access Rule Violation",
  "44": "WITH CHECK OPTION Violation",
  "53": "Insufficient Resources",
  "54": "Program Limit Exceeded",
  "55": "Object Not In Prerequisite State",
  "57": "Operator Intervention",
  "58": "System Error",
  "72": "Snapshot Failure",
  F0: "Configuration File Error",
  HV: "Foreign Data Wrapper Error",
  P0: "PL/pgSQL Error",
  XX: "Internal Error",
};

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

  // SQLSTATE is rendered once, in its own `## SQLSTATE` section (with the error
  // class), not here — keeping each derived fact to a single surface.
  rows.push(
    fact(
      "Logging API",
      doc.api.map((a) => `<code>${escapeAttr(a)}</code>`).join(" "),
    ),
  );
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

/** The GitHub source URL for a `<path>:<line>` call site: drop the checkout-root
 * `postgres/` prefix and turn `:<line>` into a `#L<line>` anchor. */
function githubUrl(site: string): string {
  const m = site.match(/^(.*):(\d+)$/);
  if (!m) return "#";
  const path = m[1]!.replace(/^postgres\//, "");
  return `https://github.com/postgres/postgres/blob/master/${path}#L${m[2]}`;
}

/** A call site rendered as a GitHub-linked code span (label keeps `path:line`). */
function siteLink(site: string): string {
  return `<a href="${escapeAttr(githubUrl(site))}"><code>${escapeHtml(site)}</code></a>`;
}

/** The `## Source` section, rendered from `call_sites` frontmatter. This is the
 * single surface for the call-site list; the body no longer restates it. */
export function sourceSection(doc: MessageDoc): string {
  const sites = doc.callSites;
  if (sites.length === 0) return "";
  if (sites.length === 1) {
    return `<h2>Source</h2>\n<p>Emitted from ${siteLink(sites[0]!)}.</p>`;
  }
  const items = sites.map((s) => `<li>${siteLink(s)}</li>`).join("");
  return `<h2>Source</h2>\n<p>This message text is emitted from ${sites.length} call sites:</p>\n<ul>${items}</ul>`;
}

/** The `## SQLSTATE` section, rendered from `sqlstate` frontmatter (code +
 * symbol + error class). Empty when the message carries no SQLSTATE. */
export function sqlstateSection(doc: MessageDoc): string {
  if (doc.sqlstate.length === 0) return "";
  const items = doc.sqlstate
    .map((s) => {
      if (s.code === "") {
        return `<li><strong>${escapeHtml(s.symbol)}</strong> — code assigned in <code>errcodes.txt</code> (outside the pilot's code map).</li>`;
      }
      const prefix = s.code.slice(0, 2).toUpperCase();
      const cls = SQLSTATE_CLASSES[prefix];
      const classText = cls ? ` Class ${prefix} (${cls}).` : "";
      return `<li><code>${escapeHtml(s.code)}</code> — <strong>${escapeHtml(s.symbol)}</strong>.${classText}</li>`;
    })
    .join("");
  return `<h2>SQLSTATE</h2>\n<ul>${items}</ul>`;
}

/** Split the body at the `## Related` heading so the generated Source/SQLSTATE
 * sections can be inserted just before it, preserving the template's order. */
function splitAtRelated(body: string): { before: string; related: string } {
  const idx = body.search(/^## Related\s*$/m);
  if (idx === -1) return { before: body, related: "" };
  return { before: body.slice(0, idx), related: body.slice(idx) };
}

/** A full message page: facts card, prose body, then the Source + SQLSTATE
 * sections rendered once from frontmatter, then the `Related` list. */
export function messagePage(doc: MessageDoc): string {
  const { before, related } = splitAtRelated(doc.body);
  const parts = [
    renderMarkdown(before, rewriteRefHref),
    sourceSection(doc),
    sqlstateSection(doc),
    related ? renderMarkdown(related, rewriteRefHref) : "",
  ].filter((part) => part !== "");
  const content = `      <article class="message">
${factsCard(doc)}
${parts.join("\n")}
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
