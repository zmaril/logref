---
message: "database \"%s\" is being used by prepared transactions"
slug: database-is-being-used-by-prepared-transactions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_IN_USE
    code: "55006"
call_sites:
  - "postgres/src/backend/storage/ipc/procarray.c:3863"
reproduced: false
---

# `database "%s" is being used by prepared transactions`

## What it means

A `DROP DATABASE` could not proceed because prepared (two-phase) transactions still reference the database. The placeholder is the database name. Prepared transactions hold resources until they are committed or rolled back. The server reports it as the object being in use.

## When it happens

It happens when you drop a database that has unresolved prepared transactions — for example left behind by an application using two-phase commit that did not finish them.

## How to fix

Resolve the outstanding prepared transactions first. List them with `SELECT * FROM pg_prepared_xacts` for that database, then `COMMIT PREPARED` or `ROLLBACK PREPARED` each one. Once none remain, the `DROP DATABASE` succeeds.

## Example

*Illustrative* — dropping a database with prepared transactions.

```sql
DROP DATABASE app;
-- ERROR:  database "app" is being used by prepared transactions
```

## Related

- [database is a system database](./database-is-a-system-database.md)
- [cursor is held from a previous transaction](./cursor-is-held-from-a-previous-transaction.md)
