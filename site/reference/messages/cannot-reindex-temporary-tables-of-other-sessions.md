---
message: "cannot reindex temporary tables of other sessions"
slug: cannot-reindex-temporary-tables-of-other-sessions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/catalog/index.c:3748"
reproduced: false
---

# `cannot reindex temporary tables of other sessions`

## What it means

A `REINDEX` touched a temporary table that belongs to another session. Temporary tables are private to their creating session, so this session cannot reindex one.

## When it happens

It occurs when a database-wide or schema-wide `REINDEX` encounters another backend's temporary table, or when one is named directly.

## How to fix

Exclude other sessions' temporary tables from the reindex, or reindex only your own objects. A database-wide `REINDEX` skips other sessions' temporary tables automatically when run appropriately.

## Example

*Illustrative* — reindexing another session's temp table.

```text
ERROR:  cannot reindex temporary tables of other sessions
```

## Related

- [cannot reindex a temporary table concurrently](./cannot-reindex-a-temporary-table-concurrently.md)
- [cannot rewrite temporary tables of other sessions](./cannot-rewrite-temporary-tables-of-other-sessions.md)
