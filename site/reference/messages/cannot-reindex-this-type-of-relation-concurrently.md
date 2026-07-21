---
message: "cannot reindex this type of relation concurrently"
slug: cannot-reindex-this-type-of-relation-concurrently
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/indexcmds.c:3996"
reproduced: false
---

# `cannot reindex this type of relation concurrently`

## What it means

A `REINDEX ... CONCURRENTLY` targeted a relation kind that does not support concurrent reindexing. The concurrent path works for ordinary tables and their indexes, and the target is a different object type.

## When it happens

It occurs when `REINDEX (CONCURRENTLY)` is run on a relation such as a system catalog or another kind that cannot be reindexed concurrently.

## How to fix

Reindex that relation with a plain `REINDEX` (no `CONCURRENTLY`), scheduling it for a quiet window if it needs a lock. Reserve concurrent reindexing for ordinary user tables and indexes.

## Example

*Illustrative* — concurrent reindex of an unsupported relation.

```text
ERROR:  cannot reindex this type of relation concurrently
```

## Related

- [cannot reindex a temporary table concurrently](./cannot-reindex-a-temporary-table-concurrently.md)
- [cannot reindex partitioned table](./cannot-reindex-partitioned-table.md)
