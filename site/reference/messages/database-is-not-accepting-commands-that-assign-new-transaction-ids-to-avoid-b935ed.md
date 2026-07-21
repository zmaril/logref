---
message: "database is not accepting commands that assign new transaction IDs to avoid wraparound data loss in database with OID %u"
slug: database-is-not-accepting-commands-that-assign-new-transaction-ids-to-avoid-b935ed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/access/transam/varsup.c:152"
reproduced: false
---

# `database is not accepting commands that assign new transaction IDs to avoid wraparound data loss in database with OID %u`

## What it means

The server has stopped accepting commands that would consume new transaction IDs in a database, to prevent transaction-ID wraparound and data loss. The placeholder is the database OID. This is the by-OID form of the wraparound stop.

## When it happens

It fires when a database's oldest unfrozen transaction age nears the wraparound limit and freezing has fallen behind, but the database is identified by OID rather than name.

## How to fix

Vacuum the affected database to freeze old rows and advance its transaction-ID horizon. Run `VACUUM` on the tables with the oldest transaction ages, and remove whatever is preventing autovacuum from freezing — long-lived transactions, stale replication slots, or unresolved prepared transactions. The database resumes accepting commands once the horizon advances.

## Example

*Illustrative* — transaction-ID wraparound protection engaged.

```text
ERROR:  database is not accepting commands that assign new transaction IDs to avoid wraparound data loss in database with OID 16384
```

## Related

- [database is not accepting commands that assign new transaction IDs (by name)](./database-is-not-accepting-commands-that-assign-new-transaction-ids-to-avoid-3db8e6.md)
- [database is not accepting commands that assign new MultiXactIds (by OID)](./database-is-not-accepting-commands-that-assign-new-multixactids-to-avoid-58aa7c.md)
