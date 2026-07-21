---
message: "database is not accepting commands that assign new MultiXactIds to avoid wraparound data loss in database \"%s\""
slug: database-is-not-accepting-commands-that-assign-new-multixactids-to-avoid-85fb72
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/access/transam/multixact.c:1038"
reproduced: false
---

# `database is not accepting commands that assign new MultiXactIds to avoid wraparound data loss in database "%s"`

## What it means

The server has stopped accepting commands that would consume new MultiXact IDs in a database, to prevent MultiXact wraparound and data loss. The placeholder is the database name. This is the by-name form of the protection.

## When it happens

It fires when a database's oldest MultiXact age approaches the wraparound limit, usually because freezing has fallen behind.

## How to fix

Vacuum the named database to advance its MultiXact horizon. Run `VACUUM` on the tables holding the oldest MultiXacts, and remove anything preventing autovacuum from freezing — long-running transactions, abandoned replication slots, or stale prepared transactions. Once old rows are frozen, the database accepts commands again.

## Example

*Illustrative* — MultiXact wraparound protection engaged.

```text
ERROR:  database is not accepting commands that assign new MultiXactIds to avoid wraparound data loss in database "app"
```

## Related

- [database is not accepting commands that assign new MultiXactIds (by OID)](./database-is-not-accepting-commands-that-assign-new-multixactids-to-avoid-58aa7c.md)
- [database is not accepting commands that assign new transaction IDs (by name)](./database-is-not-accepting-commands-that-assign-new-transaction-ids-to-avoid-3db8e6.md)
