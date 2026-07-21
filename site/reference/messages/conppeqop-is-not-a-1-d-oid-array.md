---
message: "conppeqop is not a 1-D Oid array"
slug: conppeqop-is-not-a-1-d-oid-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_constraint.c:1604"
reproduced: false
---

# `conppeqop is not a 1-D Oid array`

## What it means

Loading a foreign-key constraint, Postgres found its `conppeqop` column (the primary/parent-side equality operators) in `pg_constraint` is not the one-dimensional `oid` array it must be. This is an internal catalog consistency check.

## When it happens

It fires from foreign-key metadata loading when `conppeqop` has the wrong array shape or element type.

## How to fix

This indicates catalog corruption or direct catalog modification, not a normal error. Inspect the constraint, restore from backup if the catalog is damaged, and avoid editing `pg_constraint` manually.

## Example

*Illustrative* — a malformed conppeqop array.

```text
ERROR:  conppeqop is not a 1-D Oid array
```

## Related

- [conffeqop is not a 1-D Oid array](./conffeqop-is-not-a-1-d-oid-array.md)
- [confkey is not a 1-D smallint array](./confkey-is-not-a-1-d-smallint-array.md)
