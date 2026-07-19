---
message: "database %u does not exist"
slug: database-does-not-exist-5d0764
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_DATABASE
    code: "3D000"
call_sites:
  - "postgres/src/backend/utils/init/postinit.c:1134"
reproduced: false
---

# `database %u does not exist`

## What it means

A backend tried to attach to a database by OID during startup and found no such database. The placeholder is the numeric database OID. This is the by-OID form, used internally when a connection resolves to a database that has vanished.

## When it happens

It fires at connection startup when the target database's OID no longer exists in `pg_database` — typically the database was dropped concurrently with the connection attempt.

## How to fix

Reconnect to a database that exists. If the database was intentionally dropped, update whatever pointed a connection at it. If it disappeared unexpectedly, check who ran `DROP DATABASE` and review the server log around that time.

## Example

*Illustrative* — connecting to a dropped database by OID.

```text
FATAL:  database 16401 does not exist
```

## Related

- [database has disappeared from pg_database](./database-has-disappeared-from-pg-database.md)
- [database was concurrently dropped](./database-was-concurrently-dropped.md)
