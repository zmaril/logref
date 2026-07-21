---
message: "confkey is not a 1-D smallint array"
slug: confkey-is-not-a-1-d-smallint-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_constraint.c:1574"
reproduced: false
---

# `confkey is not a 1-D smallint array`

## What it means

Loading a foreign-key constraint, Postgres found its `confkey` column (the referenced column numbers) in `pg_constraint` is not the one-dimensional `smallint` array it must be. This is an internal catalog consistency check.

## When it happens

It fires from foreign-key metadata loading when `confkey` has an unexpected shape or element type.

## How to fix

This points to catalog corruption or manual catalog editing rather than a user error. Inspect the constraint, restore from a good backup if the catalog is damaged, and never edit `pg_constraint` by hand.

## Example

*Illustrative* — a malformed confkey array.

```text
ERROR:  confkey is not a 1-D smallint array
```

## Related

- [confdelsetcols is not a 1-D smallint array](./confdelsetcols-is-not-a-1-d-smallint-array.md)
- [conffeqop is not a 1-D Oid array](./conffeqop-is-not-a-1-d-oid-array.md)
