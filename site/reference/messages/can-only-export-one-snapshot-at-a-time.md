---
message: "can only export one snapshot at a time"
slug: can-only-export-one-snapshot-at-a-time
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/replication/logical/snapbuild.c:551"
reproduced: false
---

# `can only export one snapshot at a time`

## What it means

A transaction called `pg_export_snapshot()` more than once. A transaction may export at most one snapshot for other sessions to import, so a second export in the same transaction is rejected.

## When it happens

It occurs when `pg_export_snapshot()` is called again in a transaction that already exported a snapshot.

## How to fix

Export the snapshot once per transaction and reuse the returned identifier for all sessions that need it. If you need a fresh snapshot, do the export in a separate transaction.

## Example

*Illustrative* — exporting twice in one transaction.

```sql
BEGIN; SELECT pg_export_snapshot(); SELECT pg_export_snapshot();
```

## Related

- [can only reindex the currently open database](./can-only-reindex-the-currently-open-database.md)
- [cannot acquire replication slot](./cannot-acquire-replication-slot.md)
