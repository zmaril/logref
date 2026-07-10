// Entry point for the LogRef site landing page. Wires the search box to the
// reference index — the {slug, message, level, sqlstate} list emitted by
// build.ts and inlined here as JSON, so search runs from pure static files with
// no fetch. Filtering reuses the shared substring matcher in search.ts, and each
// result links to its generated message page.

import messages from "./generated/messages.json";
import { entryRow } from "./render.ts";
import { type MessageEntry, searchMessages } from "./search.ts";

const all = messages as MessageEntry[];

function renderList(list: MessageEntry[]): string {
  if (list.length === 0) return '<p class="empty">No matching message.</p>';
  return `<ul class="entries">${list.map(entryRow).join("")}</ul>`;
}

function mount(): void {
  const input = document.querySelector<HTMLInputElement>("#q");
  const out = document.querySelector<HTMLElement>("#results");
  const count = document.querySelector<HTMLElement>("#count");
  if (!input || !out) return;

  const update = () => {
    const q = input.value.trim();
    const hits = q === "" ? all : searchMessages(all, q);
    out.innerHTML = renderList(hits);
    if (count) {
      count.textContent =
        q === ""
          ? `${all.length} messages`
          : `${hits.length} of ${all.length} messages`;
    }
  };

  input.addEventListener("input", update);
  update();
}

if (typeof document !== "undefined") {
  mount();
}
