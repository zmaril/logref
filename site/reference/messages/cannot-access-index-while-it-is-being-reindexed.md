---
message: "cannot access index \"%s\" while it is being reindexed"
slug: cannot-access-index-while-it-is-being-reindexed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/access/index/genam.c:662"
reproduced: false
---

# `cannot access index "%s" while it is being reindexed`

## What it means

A session tried to use an index that is currently being rebuilt by a `REINDEX`. While a reindex runs, the index is not available for scans. The placeholder is the index name.

## When it happens

It occurs when a query or command needs an index at the same time another session is running `REINDEX` on it, or within the same session's nested operation.

## How to fix

Wait for the reindex to finish, then retry. To avoid blocking readers and writers during a rebuild, use `REINDEX ... CONCURRENTLY`, which keeps the old index usable until the new one is ready.

## Example

*Illustrative* — accessing an index mid-reindex.

```text
ERROR:  cannot access index "orders_pkey" while it is being reindexed
```

## Related

- [can only reindex the currently open database](./can-only-reindex-the-currently-open-database.md)
- [cannot acquire lock mode on database objects while recovery is in progress](./cannot-acquire-lock-mode-on-database-objects-while-recovery-is-in-progress.md)
