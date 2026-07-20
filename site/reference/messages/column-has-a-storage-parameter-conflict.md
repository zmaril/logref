---
message: "column \"%s\" has a storage parameter conflict"
slug: column-has-a-storage-parameter-conflict
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:3387"
reproduced: false
---

# `column "%s" has a storage parameter conflict`

## What it means

An inheritance merge produced a column whose parents assign it different storage or type settings. A merged column must have consistent storage attributes, so the conflicting definitions are rejected.

## When it happens

It occurs on `CREATE TABLE ... INHERITS (...)` when the same column comes from parents with incompatible storage or type parameters.

## How to fix

Align the column's storage and type settings across the parents so they match, then retry. Make the parents' definitions of the shared column consistent before merging.

## Example

*Illustrative* — conflicting inherited storage.

```text
ERROR:  column "c" has a storage parameter conflict
```

## Related

- [column has a collation conflict](./column-has-a-collation-conflict.md)
- [child table is missing column](./child-table-is-missing-column.md)
