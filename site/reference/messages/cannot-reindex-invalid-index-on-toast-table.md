---
message: "cannot reindex invalid index on TOAST table"
slug: cannot-reindex-invalid-index-on-toast-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/catalog/index.c:3759"
  - "postgres/src/backend/commands/indexcmds.c:3942"
reproduced: false
---

# `cannot reindex invalid index on TOAST table`

## What it means

`REINDEX` was asked to rebuild an index on a TOAST table that is marked invalid. The invalid TOAST index is a leftover from a failed concurrent build, and it cannot be reindexed in place; it must be dropped instead.

## When it happens

Running `REINDEX` (often a table- or database-wide reindex) that reaches an invalid index on a TOAST table left behind by an interrupted `CREATE INDEX CONCURRENTLY` or a failed reindex.

## How to fix

Drop the invalid TOAST index rather than reindexing it; Postgres will rebuild the TOAST table's valid index as needed. Identify invalid indexes via `pg_index.indisvalid = false` and remove the stale one, then reindex the table normally.

## Example

*Illustrative* — reindexing an invalid TOAST index.

```text
ERROR:  cannot reindex invalid index on TOAST table
```

## Related

- [cannot reindex while reindexing](./cannot-reindex-while-reindexing.md)
- [cannot modify reindex state during a parallel operation](./cannot-modify-reindex-state-during-a-parallel-operation.md)
