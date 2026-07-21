---
message: "a snapshot-importing transaction must have isolation level SERIALIZABLE or REPEATABLE READ"
slug: a-snapshot-importing-transaction-must-have-isolation-level-serializable-or
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/time/snapmgr.c:1420"
reproduced: true
---

# `a snapshot-importing transaction must have isolation level SERIALIZABLE or REPEATABLE READ`

## What it means

A transaction tried to import an exported snapshot while running at `READ COMMITTED`, but snapshot import requires the importer to be at `REPEATABLE READ` or `SERIALIZABLE` so its snapshot stays fixed.

## When it happens

It occurs when `SET TRANSACTION SNAPSHOT` is issued in a transaction that has not been set to a sufficiently high isolation level.

## How to fix

Raise the importing transaction's isolation level before importing: begin it with `ISOLATION LEVEL REPEATABLE READ` (or `SERIALIZABLE`), then run `SET TRANSACTION SNAPSHOT`. At `READ COMMITTED` each statement takes a new snapshot, so importing one is meaningless.

## Example

*Reproduced* — captured from `reproducers/scenarios/24_txn_copy_cursor.sql`.

```sql
SET TRANSACTION SNAPSHOT 'FFFFFFFF-1-1';
```

Produces:

```text
ERROR:  a snapshot-importing transaction must have isolation level SERIALIZABLE or REPEATABLE READ
```

## Related

- [a serializable transaction cannot import a snapshot from a non-serializable transaction](./a-serializable-transaction-cannot-import-a-snapshot-from-a-non-serializable.md)
- [a snapshot-importing transaction must not be READ ONLY DEFERRABLE](./a-snapshot-importing-transaction-must-not-be-read-only-deferrable.md)
