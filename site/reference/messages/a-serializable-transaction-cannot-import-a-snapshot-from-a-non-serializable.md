---
message: "a serializable transaction cannot import a snapshot from a non-serializable transaction"
slug: a-serializable-transaction-cannot-import-a-snapshot-from-a-non-serializable
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/time/snapmgr.c:1542"
reproduced: false
---

# `a serializable transaction cannot import a snapshot from a non-serializable transaction`

## What it means

A serializable transaction tried to import a snapshot that was exported by a transaction running at a lower isolation level, which cannot provide the guarantees serializable execution needs.

## When it happens

It occurs with `SET TRANSACTION SNAPSHOT` when the importer is `SERIALIZABLE` but the snapshot's source transaction ran at `REPEATABLE READ` or `READ COMMITTED`.

## How to fix

Export the snapshot from a `SERIALIZABLE` transaction, or run the importing transaction at `REPEATABLE READ` instead. The isolation level of the snapshot's origin and the importer must be compatible for serializable semantics to hold.

## Example

*Illustrative* — importing a repeatable-read snapshot into a serializable transaction.

```sql
BEGIN ISOLATION LEVEL SERIALIZABLE;
SET TRANSACTION SNAPSHOT '...';  -- source was REPEATABLE READ
```

## Related

- [a non-read-only serializable transaction cannot import a snapshot from a read-only transaction](./a-non-read-only-serializable-transaction-cannot-import-a-snapshot-from-a-read.md)
- [a snapshot-importing transaction must have isolation level SERIALIZABLE or REPEATABLE READ](./a-snapshot-importing-transaction-must-have-isolation-level-serializable-or.md)
