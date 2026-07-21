---
message: "confdelsetcols is not a 1-D smallint array"
slug: confdelsetcols-is-not-a-1-d-smallint-array
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_constraint.c:1641"
reproduced: false
---

# `confdelsetcols is not a 1-D smallint array`

## What it means

Reading a foreign key's `ON DELETE SET (columns)` list from `pg_constraint`, Postgres found the `confdelsetcols` column is not a one-dimensional `smallint` array as required. This is an internal catalog check.

## When it happens

It fires from constraint-loading code when the `confdelsetcols` array has an unexpected shape or type.

## How to fix

This signals catalog corruption or manual catalog tampering rather than a user SQL mistake. Inspect the constraint, restore from a good backup if needed, and do not edit `pg_constraint` directly.

## Example

*Illustrative* — a malformed confdelsetcols array.

```text
ERROR:  confdelsetcols is not a 1-D smallint array
```

## Related

- [confkey is not a 1-D smallint array](./confkey-is-not-a-1-d-smallint-array.md)
- [conffeqop is not a 1-D Oid array](./conffeqop-is-not-a-1-d-oid-array.md)
