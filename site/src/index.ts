// Entry point for the LogRef site. Wires the search box on the landing page to
// the in-browser index. The inventory is a static JSON asset emitted by the
// build; until it exists we ship a tiny inline sample so the page is live.

import { type LogSite, location, messageText, search } from "./search.ts";

const SAMPLE: LogSite[] = [
  {
    api: "ereport",
    kind: "backend",
    level: "ERROR",
    message: { text: 'could not open parent table of index "%s"' },
    sqlstates: ["ERRCODE_UNDEFINED_TABLE"],
    path: "postgres/contrib/amcheck/verify_common.c",
    line: 127,
  },
];

function render(results: LogSite[]): string {
  if (results.length === 0) return "<p>No matching log site.</p>";
  return results
    .map(
      (site) =>
        `<li><code>${location(site)}</code> — ${messageText(site) ?? ""}</li>`,
    )
    .join("");
}

function mount(): void {
  const input = document.querySelector<HTMLInputElement>("#q");
  const out = document.querySelector<HTMLElement>("#results");
  if (!input || !out) return;
  input.addEventListener("input", () => {
    out.innerHTML = `<ul>${render(search(SAMPLE, input.value))}</ul>`;
  });
}

if (typeof document !== "undefined") {
  mount();
}
