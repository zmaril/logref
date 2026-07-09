# LogRef

A searchable reference for database log and error messages — StackOverflow, but for log lines.
Every message is tied back to the exact source line that emits it, and enriched with community
references around it.

This directory is the design spec for the system: what LogRef is and how it works.

## Contents

- **[DESIGN.md](DESIGN.md)** — the design doc. Problem, idea, the three product surfaces
  (Search / Reference / Scan), how it works (extract → validate → enrich → serve), what the
  extracted index looks like, and open questions. **Start here.**
- **snippets/**
  - [`semgrep-rules.yml`](snippets/semgrep-rules.yml) — the rules that define "what counts as a Postgres log site" (`ereport`, `elog`, `pg_log_*`, `pg_fatal`, `write_stderr`). The operational definition of LogRef's raw material.
  - [`sample-log-sites.txt`](snippets/sample-log-sites.txt) — human-readable sample of extracted log sites (`path:line api LEVEL message`).
  - [`sample-log-sites.jsonl`](snippets/sample-log-sites.jsonl) — the structured records that back a reference page, one per line — the target output shape.

## The 30-second version

1. **Extract** every log call site from a database's source (Postgres: on the order of 14,000
   sites) → structured records with message text, severity, SQLSTATE, and `file:line` provenance.
2. **Validate** by running an instrumented build and seeing which sites actually fire → coverage /
   priority.
3. **Enrich & serve** one reference page per message + search, with aggregated links (StackOverflow,
   git commits, blogs, bug tracker, mailing list).

The provenance (message ⇄ exact source line + error code + severity) is what makes the reference
authoritative.
