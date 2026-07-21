---
message: "could not find index attname \"%s\""
slug: could-not-find-index-attname
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:11297"
reproduced: false
---

# `could not find index attname "%s"`

## What it means

`pg_dump` could not resolve a column name for an index while building its output. The `%s` gives the name it was resolving. The index's catalog information did not line up as expected.

## When it happens

It happens during a dump when `pg_dump` reads index metadata and cannot match an expected attribute name, usually from a catalog inconsistency or concurrent DDL during the dump.

## How to fix

Avoid schema changes to the indexes being dumped while `pg_dump` runs (dump against a quiet database or a snapshot). If the catalogs are stable and it still appears, note the affected index and report a reproducible case.

## Example

*Illustrative* — an index column name that cannot be resolved.

```text
pg_dump: fatal: could not find index attname "col3"
```

## Related

- [could not find parent extension for](./could-not-find-parent-extension-for.md)
- [could not find parent table of index](./could-not-find-parent-table-of-index.md)
