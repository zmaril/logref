---
message: "database is not accepting commands that assign new transaction IDs to avoid wraparound data loss in database \"%s\""
slug: database-is-not-accepting-commands-that-assign-new-transaction-ids-to-avoid-3db8e6
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/access/transam/varsup.c:145"
reproduced: false
---

# `database is not accepting commands that assign new transaction IDs to avoid wraparound data loss in database "%s"`

## What it means

The server has stopped accepting commands that would consume new transaction IDs in a database, to prevent transaction-ID wraparound and the data loss it would cause. The placeholder is the database name. This is the classic wraparound-protection stop.

## When it happens

It fires when a database's oldest unfrozen transaction age has grown perilously close to the wraparound limit because vacuum freezing has not kept up.

## How to fix

Vacuum the named database urgently to freeze old rows and advance its transaction-ID horizon. Connect to it and run `VACUUM` on the oldest tables; identify blockers of freezing — long-running or idle-in-transaction sessions, abandoned replication slots, unresolved prepared transactions — and clear them. Once the horizon advances, the database resumes accepting commands.

## Example

*Illustrative* — transaction-ID wraparound protection engaged.

```text
ERROR:  database is not accepting commands that assign new transaction IDs to avoid wraparound data loss in database "app"
```

## Related

- [database is not accepting commands that assign new transaction IDs (by OID)](./database-is-not-accepting-commands-that-assign-new-transaction-ids-to-avoid-b935ed.md)
- [database is not accepting commands that assign new MultiXactIds (by name)](./database-is-not-accepting-commands-that-assign-new-multixactids-to-avoid-85fb72.md)
