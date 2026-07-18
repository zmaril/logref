// A deliberately small markdown → HTML renderer. The reference pages use a
// narrow, known subset — headings, fenced code blocks, unordered lists,
// paragraphs, and the inline set (code spans, bold, italic, links) — so we
// render exactly that rather than depend on a full CommonMark engine. Anything
// outside the subset falls through as escaped text.

/** Escape the three HTML-significant characters. */
export function escapeHtml(text: string): string {
  return text
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}

/** Optional rewrite applied to every link `href` (e.g. `.md` → `.html`). */
export type HrefTransform = (href: string) => string;

/** Render the inline span constructs within one already-block-split string. */
export function renderInline(text: string, hrefT?: HrefTransform): string {
  let html = escapeHtml(text);
  // Code spans first so their contents are shielded from the other rules.
  html = html.replace(/`([^`]+)`/g, (_m, code) => `<code>${code}</code>`);
  // Links: text may already contain the <code> tags emitted above.
  html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, (_m, label, href) => {
    const target = hrefT ? hrefT(href) : href;
    return `<a href="${target}">${label}</a>`;
  });
  html = html.replace(/\*\*([^*]+)\*\*/g, "<strong>$1</strong>");
  html = html.replace(/\*([^*]+)\*/g, "<em>$1</em>");
  return html;
}

/** Render a markdown document to an HTML fragment. */
export function renderMarkdown(md: string, hrefT?: HrefTransform): string {
  const lines = md.split("\n");
  const out: string[] = [];
  let paragraph: string[] = [];
  let list: string[] = [];

  const flushParagraph = () => {
    if (paragraph.length > 0) {
      out.push(`<p>${renderInline(paragraph.join(" "), hrefT)}</p>`);
      paragraph = [];
    }
  };
  const flushList = () => {
    if (list.length > 0) {
      out.push(`<ul>${list.join("")}</ul>`);
      list = [];
    }
  };

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i]!;

    const fence = line.match(/^```(\w*)\s*$/);
    if (fence) {
      flushParagraph();
      flushList();
      const lang = fence[1]!;
      const code: string[] = [];
      i++;
      while (i < lines.length && !/^```\s*$/.test(lines[i]!)) {
        code.push(lines[i]!);
        i++;
      }
      const cls = lang ? ` class="language-${lang}"` : "";
      out.push(`<pre><code${cls}>${escapeHtml(code.join("\n"))}</code></pre>`);
      continue;
    }

    const heading = line.match(/^(#{1,6})\s+(.*)$/);
    if (heading) {
      flushParagraph();
      flushList();
      const level = heading[1]!.length;
      out.push(`<h${level}>${renderInline(heading[2]!, hrefT)}</h${level}>`);
      continue;
    }

    const item = line.match(/^-\s+(.*)$/);
    if (item) {
      flushParagraph();
      list.push(`<li>${renderInline(item[1]!, hrefT)}</li>`);
      continue;
    }

    if (line.trim() === "") {
      flushParagraph();
      flushList();
      continue;
    }

    flushList();
    paragraph.push(line.trim());
  }

  flushParagraph();
  flushList();
  return out.join("\n");
}
