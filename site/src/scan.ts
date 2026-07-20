// Browser entry point for the Scan page. Fetches the build-time pattern index
// (patterns.json), compiles it into a trigram-prefiltered ScanIndex, and wires
// the textarea + file input so a user can resolve their own log lines to catalog
// message pages — with the variable bits pulled out. Everything runs client-side:
// the pasted text and any uploaded file are read with the File API and matched
// locally; nothing is ever sent to a server.

import {
  type LineResult,
  type MatchHit,
  type PatternEntry,
  ScanIndex,
} from "./scanner.ts";

/** Cap on line-cards rendered, so a huge paste can't lock up the DOM. */
const MAX_RENDERED = 500;
/** Cap on how many input lines we scan at all. */
const MAX_LINES = 20000;

function severityTier(level: string): "error" | "warn" | "info" {
  if (["ERROR", "FATAL", "PANIC", "COMMERROR"].includes(level)) return "error";
  if (level === "WARNING") return "warn";
  return "info";
}

function badge(level: string): HTMLElement {
  const el = document.createElement("span");
  el.className = `badge badge-${severityTier(level)}`;
  el.textContent = level;
  return el;
}

function el(tag: string, className?: string, text?: string): HTMLElement {
  const node = document.createElement(tag);
  if (className) node.className = className;
  if (text !== undefined) node.textContent = text;
  return node;
}

/** Build the card for a single scanned line. */
function renderLine(result: LineResult): HTMLElement {
  const card = el("div", "scan-line");
  const top = result.hits[0];

  const status = el("div", "scan-line-status");
  if (!top) status.classList.add("no-match");
  else if (result.hits.length > 1) status.classList.add("ambiguous");
  else status.classList.add("matched");
  if (result.detectedLevel) status.appendChild(badge(result.detectedLevel));

  const rawEl = el("code", "scan-raw", result.raw);
  status.appendChild(rawEl);
  card.appendChild(status);

  if (!top) {
    card.appendChild(
      el("div", "scan-verdict no-match-text", "No catalog match"),
    );
    return card;
  }

  card.appendChild(renderHit(top, result.hits.length));
  return card;
}

function renderHit(hit: MatchHit, hitCount: number): HTMLElement {
  const wrap = el("div", "scan-verdict");

  const line = el("div", "scan-match-line");
  const link = document.createElement("a");
  link.className = "scan-match-msg";
  link.href = `messages/${encodeURIComponent(hit.pattern.slug)}.html`;
  link.textContent = hit.pattern.message;
  line.appendChild(link);
  for (const lvl of hit.pattern.level) line.appendChild(badge(lvl));
  if (hitCount > 1) {
    line.appendChild(
      el("span", "flag flag-ambiguous", `+${hitCount - 1} more · ambiguous`),
    );
  }
  wrap.appendChild(line);

  if (hit.captures.length > 0) {
    const caps = el("div", "scan-captures");
    for (const c of hit.captures) {
      const chip = el("span", "capture");
      chip.appendChild(el("span", "capture-spec", c.spec));
      chip.appendChild(
        el("span", "capture-value", c.value === "" ? "∅" : c.value),
      );
      caps.appendChild(chip);
    }
    wrap.appendChild(caps);
  }
  return wrap;
}

function splitLines(text: string): string[] {
  return text
    .split(/\r?\n/)
    .map((l) => l.trimEnd())
    .filter((l) => l.trim() !== "");
}

function mount(): void {
  const input = document.querySelector<HTMLTextAreaElement>("#scan-input");
  const file = document.querySelector<HTMLInputElement>("#scan-file");
  const runBtn = document.querySelector<HTMLButtonElement>("#scan-run");
  const clearBtn = document.querySelector<HTMLButtonElement>("#scan-clear");
  const status = document.querySelector<HTMLElement>("#scan-status");
  const out = document.querySelector<HTMLElement>("#scan-results");
  if (!input || !runBtn || !status || !out) return;

  let index: ScanIndex | null = null;
  const ready = fetch("patterns.json")
    .then((r) => r.json() as Promise<PatternEntry[]>)
    .then((patterns) => {
      index = new ScanIndex(patterns);
      status.textContent = `Ready — matching against ${patterns.length} lowered patterns (${index.catchAllCount} held-back catch-alls).`;
    })
    .catch(() => {
      status.textContent = "Failed to load the pattern index.";
    });

  const run = async () => {
    await ready;
    if (!index) return;
    let lines = splitLines(input.value);
    const truncatedInput = lines.length > MAX_LINES;
    if (truncatedInput) lines = lines.slice(0, MAX_LINES);

    if (lines.length === 0) {
      out.replaceChildren();
      status.textContent = "Paste or upload some log lines to scan.";
      return;
    }

    const t0 = performance.now();
    const results = lines.map((l) => index!.scanLine(l));
    const ms = performance.now() - t0;

    let matched = 0;
    let ambiguous = 0;
    let unmatched = 0;
    for (const r of results) {
      if (r.hits.length === 0) unmatched++;
      else {
        matched++;
        if (r.hits.length > 1) ambiguous++;
      }
    }

    const frag = document.createDocumentFragment();
    for (const r of results.slice(0, MAX_RENDERED))
      frag.appendChild(renderLine(r));
    out.replaceChildren(frag);

    const rate = ms > 0 ? Math.round(lines.length / (ms / 1000)) : lines.length;
    const shown =
      results.length > MAX_RENDERED ? ` Showing first ${MAX_RENDERED}.` : "";
    const trunc = truncatedInput ? ` Input capped at ${MAX_LINES} lines.` : "";
    status.textContent =
      `${lines.length} lines · ${matched} matched (${ambiguous} ambiguous) · ` +
      `${unmatched} unmatched · ` +
      `${ms.toFixed(0)}ms (~${rate.toLocaleString()} lines/s).${shown}${trunc}`;
  };

  runBtn.addEventListener("click", run);
  clearBtn?.addEventListener("click", () => {
    input.value = "";
    out.replaceChildren();
    if (index) {
      status.textContent = `Ready — matching against ${index.patternCount} lowered patterns.`;
    }
  });

  file?.addEventListener("change", async () => {
    const f = file.files?.[0];
    if (!f) return;
    status.textContent = `Reading ${f.name}…`;
    input.value = await f.text();
    await run();
  });
}

if (typeof document !== "undefined") {
  mount();
}
