---
message: "archive format \"%s\" is not supported; please use psql"
slug: archive-format-is-not-supported-please-use-psql
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_restore.c:480"
reproduced: false
---

# `archive format "%s" is not supported; please use psql`

## What it means

A restore tool was pointed at a dump that is in plain-text (SQL script) format, which it cannot process; that format must be replayed with `psql` instead.

## When it happens

It occurs when `pg_restore` is given a plain-format dump (produced by `pg_dump -Fp`) rather than one of the archive formats it understands (custom, directory, or tar).

## How to fix

Restore plain-format dumps with `psql -f dumpfile dbname`. Use `pg_restore` only for the custom (`-Fc`), directory (`-Fd`), or tar (`-Ft`) formats. If you want `pg_restore`'s selective-restore features, re-dump with one of those archive formats.

## Example

*Illustrative* — pg_restore given a plain SQL dump.

```text
pg_restore: archive format "plain" is not supported; please use psql
```

## Related

- [already connected to a database](./already-connected-to-a-database.md)
- [archive file already exists](./archive-file-already-exists.md)
