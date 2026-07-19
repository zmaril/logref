---
message: "cannot PREPARE a transaction that has exported snapshots"
slug: cannot-prepare-a-transaction-that-has-exported-snapshots
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:2668"
reproduced: false
---

# `cannot PREPARE a transaction that has exported snapshots`

## What it means

A `PREPARE TRANSACTION` was rejected because the transaction exported a snapshot with `pg_export_snapshot()`. An exported snapshot is valid only while its exporting transaction is live, which two-phase commit cannot guarantee.

## When it happens

It occurs when a session calls `pg_export_snapshot()` and then runs `PREPARE TRANSACTION`.

## How to fix

Do not export snapshots in transactions that use two-phase commit. Let any snapshot-sharing complete and the transaction end normally, then use a separate prepared transaction for the two-phase work.

## Example

*Illustrative* — PREPARE after exporting a snapshot.

```text
ERROR:  cannot PREPARE a transaction that has exported snapshots
```

## Related

- [cannot export a snapshot from a subtransaction](./cannot-export-a-snapshot-from-a-subtransaction.md)
- [cannot PREPARE a transaction that has created a cursor WITH HOLD](./cannot-prepare-a-transaction-that-has-created-a-cursor-with-hold.md)
