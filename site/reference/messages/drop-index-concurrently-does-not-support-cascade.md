---
message: "DROP INDEX CONCURRENTLY does not support CASCADE"
slug: drop-index-concurrently-does-not-support-cascade
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:1620"
reproduced: false
---

# `DROP INDEX CONCURRENTLY does not support CASCADE`

## What it means

`DROP INDEX CONCURRENTLY` was given `CASCADE`. The concurrent form of the command cannot cascade to dependent objects, so `CASCADE` is not allowed.

## When it happens

It fires from `DROP INDEX CONCURRENTLY ... CASCADE`.

## How to fix

Drop the index concurrently without `CASCADE` (concurrent drop is only for plain, non-cascading index removal), or use a plain `DROP INDEX ... CASCADE` if you accept the brief exclusive lock and need cascading.

## Example

*Illustrative* — CASCADE with a concurrent drop.

```sql
DROP INDEX CONCURRENTLY my_idx CASCADE;
-- DROP INDEX CONCURRENTLY does not support CASCADE
```

## Related

- [DROP INDEX CONCURRENTLY does not support dropping multiple objects](./drop-index-concurrently-does-not-support-dropping-multiple-objects.md)
- [DROP INDEX CONCURRENTLY must be first action in transaction](./drop-index-concurrently-must-be-first-action-in-transaction.md)
