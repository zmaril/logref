---
message: "database is not accepting commands that assign new MultiXactIds to avoid wraparound data loss in database with OID %u"
slug: database-is-not-accepting-commands-that-assign-new-multixactids-to-avoid-58aa7c
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/access/transam/multixact.c:1045"
reproduced: false
---

# `database is not accepting commands that assign new MultiXactIds to avoid wraparound data loss in database with OID %u`

## What it means

The server has stopped accepting commands that would consume new MultiXact IDs in a database, to prevent MultiXact wraparound and the data loss it would cause. The placeholder is the database OID. MultiXacts track sets of transactions locking a row, and their ID space must not wrap.

## When it happens

It fires when a database's oldest MultiXact age has grown dangerously close to the wraparound limit because autovacuum has not been able to freeze old rows fast enough.

## How to fix

Vacuum to advance the MultiXact horizon. Connect to the named database and run `VACUUM` (a database-wide vacuum) on the tables with the oldest MultiXacts, and make sure autovacuum is running and not being blocked by long-lived transactions or held prepared transactions. Free the blockers, let vacuum freeze old rows, and normal operation resumes.

## Example

*Illustrative* — MultiXact wraparound protection engaged.

```text
ERROR:  database is not accepting commands that assign new MultiXactIds to avoid wraparound data loss in database with OID 16384
```

## Related

- [database is not accepting commands that assign new MultiXactIds (by name)](./database-is-not-accepting-commands-that-assign-new-multixactids-to-avoid-85fb72.md)
- [database is not accepting commands that assign new transaction IDs (by name)](./database-is-not-accepting-commands-that-assign-new-transaction-ids-to-avoid-3db8e6.md)
