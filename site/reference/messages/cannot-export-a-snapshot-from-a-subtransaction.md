---
message: "cannot export a snapshot from a subtransaction"
slug: cannot-export-a-snapshot-from-a-subtransaction
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ACTIVE_SQL_TRANSACTION
    code: "25001"
call_sites:
  - "postgres/src/backend/utils/time/snapmgr.c:1154"
reproduced: false
---

# `cannot export a snapshot from a subtransaction`

## What it means

`pg_export_snapshot()` was called while a subtransaction was open. An exported snapshot must belong to the top-level transaction so other sessions can import it consistently, so exporting from within a savepoint is rejected.

## When it happens

It occurs when the exporting session has an open savepoint or is inside a PL/pgSQL block with an exception handler (which runs as a subtransaction) at the moment it calls `pg_export_snapshot()`.

## How to fix

Export the snapshot from the top-level transaction, before entering any savepoint or exception-handling block. Release or roll back the subtransaction first, then export.

## Example

*Illustrative* — export attempted inside a savepoint.

```text
ERROR:  cannot export a snapshot from a subtransaction
```

## Related

- [cannot import a snapshot from a different database](./cannot-import-a-snapshot-from-a-different-database.md)
- [cannot export a snapshot from within a transaction](./cannot-export-a-snapshot-from-within-a-transaction.md)
