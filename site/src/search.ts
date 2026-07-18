// Client-side search over the LogRef index. The pages served by this site load
// the extracted inventory (produced by the Rust core) and resolve a user's
// pasted log line to the source sites it came from. The matching here mirrors
// `logref-core`'s placeholder substring search; a real ranked engine (e.g.
// Orama) replaces it as the site grows. See ../../notes/design.md.

export type Kind = "backend" | "frontend" | "stderr" | "unknown";

export interface LogSite {
  api: string;
  kind: Kind;
  level?: string;
  message: { expr?: string; text?: string };
  sqlstates?: string[];
  path: string;
  line: number;
}

/** One entry in the reference index: a distinct message text and its facts.
 * Emitted at build time by build.ts, one per generated page. */
export interface MessageEntry {
  slug: string;
  message: string;
  level: string[];
  sqlstate: string[];
}

/** Best human-readable form of a site's message. */
export function messageText(site: LogSite): string | undefined {
  return site.message.text ?? site.message.expr;
}

/** The provenance handle, `path:line`. */
export function location(site: LogSite): string {
  return `${site.path}:${site.line}`;
}

/** Case-insensitive substring test; an empty/blank needle never matches. */
export function matches(haystack: string | undefined, needle: string): boolean {
  const q = needle.toLowerCase().trim();
  if (q === "") return false;
  return haystack?.toLowerCase().includes(q) ?? false;
}

/** Case-insensitive substring search over each site's message text. */
export function search(index: readonly LogSite[], query: string): LogSite[] {
  return index.filter((site) => matches(messageText(site), query));
}

/** Substring search over the reference index by message text. */
export function searchMessages(
  index: readonly MessageEntry[],
  query: string,
): MessageEntry[] {
  return index.filter((entry) => matches(entry.message, query));
}
