---
message: "DROP INDEX CONCURRENTLY must be first action in transaction"
slug: drop-index-concurrently-must-be-first-action-in-transaction
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/catalog/index.c:2238"
reproduced: false
---

# `DROP INDEX CONCURRENTLY must be first action in transaction`

## What it means

`DROP INDEX CONCURRENTLY` was run inside an already-open transaction block. The concurrent drop manages its own transactions internally, so it must be the first (and only) statement of its transaction and cannot run inside `BEGIN ... COMMIT`.

## When it happens

It fires when `DROP INDEX CONCURRENTLY` is issued after other statements in an explicit transaction block.

## How to fix

Run `DROP INDEX CONCURRENTLY` outside any explicit transaction — in autocommit mode as a standalone statement. Commit or roll back the current transaction first, then issue the concurrent drop on its own.

## Example

*Illustrative* — a concurrent drop inside a transaction block.

```sql
BEGIN;
DROP INDEX CONCURRENTLY my_idx;
-- DROP INDEX CONCURRENTLY must be first action in transaction
```

## Related

- [DROP INDEX CONCURRENTLY does not support CASCADE](./drop-index-concurrently-does-not-support-cascade.md)
- [DROP INDEX CONCURRENTLY does not support dropping multiple objects](./drop-index-concurrently-does-not-support-dropping-multiple-objects.md)
