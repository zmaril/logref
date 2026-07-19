---
message: "database \"%s\" has disappeared from pg_database"
slug: database-has-disappeared-from-pg-database
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_DATABASE
    code: "3D000"
call_sites:
  - "postgres/src/backend/utils/init/postinit.c:355"
reproduced: false
---

# `database "%s" has disappeared from pg_database`

## What it means

During connection startup the database the session was attaching to was removed from `pg_database` out from under it. The placeholder is the database name. The catalog row that described the database is gone.

## When it happens

It fires when a `DROP DATABASE` runs concurrently with a new connection to that database, so the connecting backend finds the catalog entry removed mid-startup.

## How to fix

Connect to a database that still exists. This is expected if the database was being dropped as you connected; retry against a valid database. If it was not intentional, find out who dropped the database and why from the server log.

## Example

*Illustrative* — the database was dropped during connect.

```text
FATAL:  database "temp_db" has disappeared from pg_database
```

## Related

- [database does not exist (by OID)](./database-does-not-exist-5d0764.md)
- [database was concurrently dropped](./database-was-concurrently-dropped.md)
