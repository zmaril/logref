// The one place that maps a Postgres log level to a severity tier. Both the
// static renderer (render.ts) and the client-side scanner (scan.ts) derive
// their `badge badge-<tier>` class from this, so the mapping lives here once
// rather than being cloned into each surface.

export type SeverityTier = "error" | "warn" | "info";

/** Severity tiers drive badge colour: hard failures, warnings, everything else. */
export function severityTier(level: string): SeverityTier {
  if (["ERROR", "FATAL", "PANIC", "COMMERROR"].includes(level)) return "error";
  if (level === "WARNING") return "warn";
  return "info";
}
