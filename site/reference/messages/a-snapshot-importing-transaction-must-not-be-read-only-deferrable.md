---
message: "a snapshot-importing transaction must not be READ ONLY DEFERRABLE"
slug: a-snapshot-importing-transaction-must-not-be-read-only-deferrable
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/storage/lmgr/predicate.c:1675"
reproduced: false
---

# `a snapshot-importing transaction must not be READ ONLY DEFERRABLE`

## What it means

A transaction tried to import an exported snapshot while marked `READ ONLY DEFERRABLE`, which is incompatible because a deferrable transaction waits to acquire its own safe snapshot rather than adopting an imported one.

## When it happens

It occurs when `SET TRANSACTION SNAPSHOT` is combined with the `READ ONLY DEFERRABLE` attributes.

## How to fix

Drop the `DEFERRABLE` attribute from the importing transaction so it can take the imported snapshot. Use `READ ONLY` without `DEFERRABLE`, or do not import a snapshot if you specifically want deferrable behavior.

## Example

*Illustrative* — importing a snapshot into a deferrable transaction.

```sql
BEGIN ISOLATION LEVEL SERIALIZABLE READ ONLY DEFERRABLE;
SET TRANSACTION SNAPSHOT '...';  -- ERROR
```

## Related

- [a snapshot-importing transaction must have isolation level SERIALIZABLE or REPEATABLE READ](./a-snapshot-importing-transaction-must-have-isolation-level-serializable-or.md)
- [a non-read-only serializable transaction cannot import a snapshot from a read-only transaction](./a-non-read-only-serializable-transaction-cannot-import-a-snapshot-from-a-read.md)
