---
message: "database %u was concurrently dropped"
slug: database-was-concurrently-dropped
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/catalog/pg_shdepend.c:1246"
reproduced: false
---

# `database %u was concurrently dropped`

## What it means

An operation touching shared dependencies found that a database it referenced was dropped while the work was in progress. The placeholder is the database OID. The server reports it as the object being undefined.

## When it happens

It fires when a `DROP DATABASE` runs concurrently with another operation that was consulting shared catalog dependencies for that database, so the database is gone by the time the operation reaches it.

## How to fix

This is a race between a drop and another command. Retry the operation; with the database now gone, it should proceed against the remaining objects. If the drop was unintended, review the server log to see who ran it and when.

## Example

*Illustrative* — a database dropped mid-operation.

```text
ERROR:  database 16401 was concurrently dropped
```

## Related

- [database has disappeared from pg_database](./database-has-disappeared-from-pg-database.md)
- [database does not exist (by OID)](./database-does-not-exist-5d0764.md)
