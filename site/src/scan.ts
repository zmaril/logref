// Browser entry point for the Scan page. Loads the wasm build of the REAL Rust
// scanner (logref_wasm_bg.wasm, built from crates/logref-core), fetches the
// build-time site index (scan-index.json), constructs the wasm `Scanner` over
// it, and wires the textarea + file input so a user can resolve their own log
// lines to catalog message pages — with the variable bits pulled out.
// Everything runs client-side: the pasted text and any uploaded file are read
// with the File API and matched locally; nothing is ever sent to a server.

import { severityTier } from "./severity.ts";
import init, { Scanner } from "./wasm/logref_wasm.js";
import {
  type LineResult,
  type ScanIndexFile,
  type ScanSite,
  type SiteHit,
  scanLines,
  sitesToJsonl,
} from "./wasmScanner.ts";

/** Cap on line-cards rendered, so a huge paste can't lock up the DOM. */
const MAX_RENDERED = 500;
/** Cap on how many input lines we scan at all. */
const MAX_LINES = 20000;

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

function renderHit(hit: SiteHit, hitCount: number): HTMLElement {
  const wrap = el("div", "scan-verdict");

  const line = el("div", "scan-match-line");
  const link = document.createElement("a");
  link.className = "scan-match-msg";
  link.href = `messages/${encodeURIComponent(hit.site.slug)}.html`;
  link.textContent = hit.site.message;
  line.appendChild(link);
  for (const lvl of hit.site.level) line.appendChild(badge(lvl));
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

  let scanner: Scanner | null = null;
  let sites: ScanSite[] = [];
  let readyText = "";
  // Both fetches are relative to the page URL — scan.html sits at the dist
  // root, next to scan-index.json and logref_wasm_bg.wasm.
  const ready = Promise.all([
    init({ module_or_path: "logref_wasm_bg.wasm" }),
    fetch("scan-index.json").then((r) => r.json() as Promise<ScanIndexFile>),
  ])
    .then(([, index]) => {
      const t0 = performance.now();
      scanner = new Scanner(sitesToJsonl(index.sites));
      const buildMs = performance.now() - t0;
      sites = index.sites;
      readyText =
        `Ready — matching against ${scanner.report().compiled} lowered patterns ` +
        `(${index.catchAlls} held-back catch-alls, scanner built in ${buildMs.toFixed(0)}ms).`;
      status.textContent = readyText;
    })
    .catch(() => {
      status.textContent = "Failed to load the scanner.";
    });

  const run = async () => {
    await ready;
    if (!scanner) return;
    let lines = splitLines(input.value);
    const truncatedInput = lines.length > MAX_LINES;
    if (truncatedInput) lines = lines.slice(0, MAX_LINES);

    if (lines.length === 0) {
      out.replaceChildren();
      status.textContent = "Paste or upload some log lines to scan.";
      return;
    }

    const t0 = performance.now();
    const results = scanLines(scanner, sites, lines);
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
    if (scanner) status.textContent = readyText;
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
