---
message: "conexclop is not a 1-D Oid array"
slug: conexclop-is-not-a-1-d-oid-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/relcache.c:5750"
reproduced: false
---

# `conexclop is not a 1-D Oid array`

## What it means

While loading a relation's cache entry, Postgres found that the `conexclop` column of an exclusion constraint in `pg_constraint` is not the one-dimensional `oid` array it must be. This is an internal catalog consistency check.

## When it happens

It fires from relcache building when reading exclusion-constraint metadata whose `conexclop` array has the wrong shape or element type.

## How to fix

This indicates catalog corruption or improper direct catalog modification, not a normal SQL error. Investigate the affected constraint, restore from backup if the catalog is damaged, and avoid manual edits to `pg_constraint`.

## Example

*Illustrative* — a malformed conexclop array.

```text
ERROR:  conexclop is not a 1-D Oid array
```

## Related

- [conffeqop is not a 1-D Oid array](./conffeqop-is-not-a-1-d-oid-array.md)
- [confkey is not a 1-D smallint array](./confkey-is-not-a-1-d-smallint-array.md)
