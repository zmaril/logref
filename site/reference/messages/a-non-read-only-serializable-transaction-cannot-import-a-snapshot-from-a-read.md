---
message: "a non-read-only serializable transaction cannot import a snapshot from a read-only transaction"
slug: a-non-read-only-serializable-transaction-cannot-import-a-snapshot-from-a-read
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/time/snapmgr.c:1546"
reproduced: false
---

# `a non-read-only serializable transaction cannot import a snapshot from a read-only transaction`

## What it means

A serializable transaction that is not read-only tried to import a snapshot taken by a read-only transaction, which is not permitted because their serialization guarantees are incompatible.

## When it happens

It occurs with `SET TRANSACTION SNAPSHOT` when the importing transaction is `SERIALIZABLE` and read-write, but the exported snapshot came from a read-only serializable transaction.

## How to fix

Either make the importing transaction read-only (`SET TRANSACTION READ ONLY`) to match the snapshot's source, or export the snapshot from a transaction whose read-only property matches what the importer needs. Serializable snapshot sharing requires the read-only attributes to be compatible.

## Example

*Illustrative* — importing a read-only snapshot into a read-write serializable transaction.

```sql
BEGIN ISOLATION LEVEL SERIALIZABLE;
SET TRANSACTION SNAPSHOT '00000003-...';  -- source was READ ONLY
```

## Related

- [a serializable transaction cannot import a snapshot from a non-serializable transaction](./a-serializable-transaction-cannot-import-a-snapshot-from-a-non-serializable.md)
- [a snapshot-importing transaction must not be READ ONLY DEFERRABLE](./a-snapshot-importing-transaction-must-not-be-read-only-deferrable.md)
