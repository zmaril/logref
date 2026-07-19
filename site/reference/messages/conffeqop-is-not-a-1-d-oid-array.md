---
message: "conffeqop is not a 1-D Oid array"
slug: conffeqop-is-not-a-1-d-oid-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_constraint.c:1619"
reproduced: false
---

# `conffeqop is not a 1-D Oid array`

## What it means

Loading a foreign-key constraint, Postgres found its `conffeqop` column (the foreign-side equality operators) in `pg_constraint` is not the one-dimensional `oid` array it must be. This is an internal catalog consistency check.

## When it happens

It fires from foreign-key metadata loading when `conffeqop` has the wrong array shape or element type.

## How to fix

This reflects catalog corruption or direct catalog modification, not a normal error path. Examine the constraint, restore from backup if the catalog is damaged, and avoid manual `pg_constraint` edits.

## Example

*Illustrative* — a malformed conffeqop array.

```text
ERROR:  conffeqop is not a 1-D Oid array
```

## Related

- [conppeqop is not a 1-D Oid array](./conppeqop-is-not-a-1-d-oid-array.md)
- [confkey is not a 1-D smallint array](./confkey-is-not-a-1-d-smallint-array.md)
