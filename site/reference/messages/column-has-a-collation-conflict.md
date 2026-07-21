---
message: "column \"%s\" has a collation conflict"
slug: column-has-a-collation-conflict
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_COLLATION_MISMATCH
    code: "42P21"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:3367"
reproduced: false
---

# `column "%s" has a collation conflict`

## What it means

An inheritance or partition merge produced a column that inherits different collations from different parents. A merged column must have one collation, so conflicting inherited collations are rejected.

## When it happens

It occurs on `CREATE TABLE ... INHERITS (...)` or partition attachment when the same column comes from parents that assign it different collations.

## How to fix

Make the parents agree on the column's collation, or set an explicit collation on the child column so there is one consistent choice. Align the collations before merging.

## Example

*Illustrative* — conflicting inherited collations.

```text
ERROR:  column "c" has a collation conflict
```

## Related

- [column has a storage parameter conflict](./column-has-a-storage-parameter-conflict.md)
- [collation mismatch between explicit collations and](./collation-mismatch-between-explicit-collations-and.md)
