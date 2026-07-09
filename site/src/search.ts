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

/** Best human-readable form of a site's message. */
export function messageText(site: LogSite): string | undefined {
  return site.message.text ?? site.message.expr;
}

/** The provenance handle, `path:line`. */
export function location(site: LogSite): string {
  return `${site.path}:${site.line}`;
}

/** Case-insensitive substring search over each site's message text. */
export function search(index: readonly LogSite[], query: string): LogSite[] {
  const needle = query.toLowerCase().trim();
  if (needle === "") return [];
  return index.filter((site) =>
    messageText(site)?.toLowerCase().includes(needle),
  );
}
