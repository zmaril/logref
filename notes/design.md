# LogRef — Design Doc

> A searchable reference for database log and error messages — StackOverflow, but for log lines.

This document describes what LogRef is and how it works. It is a design spec for the system we are
building, not a record of past work.

---

## 1. The problem

Databases emit thousands of terse, cryptic log and error strings:

```
could not open parent table of index "%s"
number of items mismatch in GIN entry tuple, %d in tuple header, %d decoded
cannot verify unlogged index "%s" during recovery, skipping
```

When a developer or DBA hits one of these in production, the current experience is bad:

- The message is a **format string**, not the actual text they see, so search is unreliable.
- There's no canonical page that says *what this message means, what emits it, and how serious it is.*
- Answers are scattered across StackOverflow, git commits, blog posts, bug trackers, and mailing lists — with no single hub.
- The official docs describe features, not the **log surface** of the database.

There is no "StackOverflow for database log lines." That's the gap LogRef fills.

## 2. The idea

**LogRef is a search engine and reference site for database log/error messages, where every message is tied back to the exact source line that emits it, and enriched with community references around it.**

The key insight: a database's log surface is **finite and enumerable**. Every message a database can print comes from a specific `ereport()` / `elog()` / `pg_log_*()` call site in its C source. By mining all of those call sites — with their text, severity, error code, and `file:line` provenance — we build a complete, authoritative index of everything the database can ever say. That index becomes the backbone of a reference site.

Analogy: LogRef is to database log messages what StackOverflow is to programming questions and what a symbol/API reference is to a language — a canonical, searchable page per unit, aggregating the best available knowledge.

## 3. What it does (product surfaces)

Three surfaces: **Search** and **Reference** are the primary ones, **Scan** comes later.

### Reference
One canonical page per log message. For `could not open parent table of index "%s"` the page shows:
- the **message** (with `%s`-style parameters called out)
- the **severity** (`ERROR`) and the **SQLSTATE** (`ERRCODE_UNDEFINED_TABLE`)
- **where it comes from** — `postgres/contrib/amcheck/verify_common.c:127` — and the surrounding call
- aggregated **references**: StackOverflow threads, the git commit that introduced it, relevant blog posts, bug-tracker entries, mailing-list discussion

These pages are auto-generated from the extracted inventory, then enriched — one authoritative landing point for every cryptic message a user searches for.

### Search
Search across the whole inventory — by message text, error code, severity, or subsystem — and resolve the format-string-vs-rendered-text problem so a user can paste the log line they actually saw and find the right page.

### Scan (later)
Point it at your own logs and have it resolve each line back to its source site + reference page — a diagnostic tool built on the same index. Deliberately not the first thing we build.

## 4. How it works

Two stages: **build the index**, then **build the site on top of it**.

```
   Database source (Postgres C code)
              │
              │   [1] EXTRACT — statically mine every log call site
              ▼
   Structured inventory: { message, level, sqlstate, params, file:line }
              │
              │   [2] VALIDATE — run the DB and see which sites actually fire
              ▼
   Coverage data: which messages are real / common in practice
              │
              │   [3] ENRICH & SERVE — one page per message + search + aggregated links
              ▼
   Reference pages · Search · (Scan)
```

### Stage 1 — Extract the log surface

Scan the database source for its logging APIs and turn each call into a structured record. For Postgres the logging APIs are `ereport()`, `ereport_domain()`, `elog()` (backend); `pg_log_error/warning/info/debug/...` and `pg_fatal()` (frontend tools); and `write_stderr()` (early startup). Each extracted record captures the message text, severity level, SQLSTATE error code, detail/hint/context sub-messages, and — critically — the **`path:line`** provenance.

The mechanism is deliberately simple and language-appropriate: pattern-match the call sites (Semgrep over the Postgres C source — see `../snippets/semgrep-rules.yml`), then parse each call's arguments to pull the literal message out of `gettext`/string-concatenation wrappers. `../snippets/sample-log-sites.jsonl` shows the target shape of a record.

> **Provenance is what makes the index authoritative.** Scraping raw error strings is easy; tying each one to its exact source line, error code, and severity is what turns a list of strings into a precise, verifiable reference.

### Stage 2 — Validate against runtime

A static list of call sites doesn't tell you which messages *matter*. So an instrumented build of the database records the `file:line` of every log site that actually fires while running realistic scenarios (normal DDL/DML, a config failure, a crash-recovery restart). Comparing runtime hits against the static inventory yields **coverage** — which sites are exercised in practice — so reference and search can prioritize the messages people actually hit.

### Stage 3 — Enrich and serve

Auto-generate a reference page per message from the inventory, layer in aggregated external references (StackOverflow, git commits, blogs, bug tracker, mailing list), and expose search over the whole set. This is the public site.

## 5. Scope

- **One database at a time.** The first target is **Postgres** — go deep and be the best reference for it before expanding.
- **Quality over completeness in the content layer.** Best possible answers/articles per message, not an auto-dumped wall of format strings.
- **Extraction is per-database.** Each database needs its own extractor (different logging APIs), but the inventory → validate → enrich → serve shape is identical everywhere.

## 6. What the extracted index looks like (Postgres)

Postgres exposes on the order of **~14,000 log call sites** across its source tree. Broken down by
logging API, the largest groups are:

| API | approx. count | | API | approx. count |
|---|--:|---|---|--:|
| `ereport` | 7,400 | | `pg_log_error` | 630 |
| `elog` | 4,400 | | `pg_log_info` | 200 |
| `pg_fatal` | 1,200 | | `write_stderr` | 150 |

By severity, `ERROR` dominates (~9,000+), followed by `LOG`, `WARNING`, `FATAL`, and the `DEBUG*`
levels.

One record in the target shape (see `../snippets/sample-log-sites.jsonl`):

```json
{
  "api": "ereport",
  "kind": "backend",
  "level": "ERROR",
  "message": { "text": "could not open parent table of index \"%s\"" },
  "sqlstates": ["ERRCODE_UNDEFINED_TABLE"],
  "path": "postgres/contrib/amcheck/verify_common.c",
  "line": 127
}
```

That single record is enough to auto-generate a reference page: the message, its severity, its error code, and exactly where in Postgres it lives.

## 7. Repository layout

The system splits along the two stages above — a Rust core that builds and
serves the index, and a Bun site that presents it.

```
crates/
  logref-core/   library — the LogSite model + the in-memory Index (extraction
                 and coverage build on these types)
  logref-scan/   binary  — the `scan` CLI: resolve log lines against an index
site/            the Bun website — Search and the generated Reference pages
notes/design.md  this document
snippets/        representative artifacts (extraction rules, sample records)
```

The Rust workspace owns everything that touches source and produces the
inventory; `site/` owns everything a reader sees. The JSON record shape in §6 is
the contract between them — `logref-core` emits it, `site/src/search.ts`
consumes it.

## 8. Open questions

- **Enrichment.** How the reference layer aggregates and ranks external references (StackOverflow, git commits, blogs, bug tracker, mailing list) per message.
- **Format-string ↔ rendered-text matching.** How a user's pasted, fully-rendered log line resolves back to the `%s`-parameterized format string in the index.
- **Multi-database.** Extractors beyond Postgres (e.g. MySQL) share the pipeline shape but need their own log-site definitions.

---

*See `../snippets/` for representative artifacts: the Semgrep rules that define "what is a log site" and sample records in the target shape.*
