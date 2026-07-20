---
message: "database \"%s\" is not currently accepting connections"
slug: database-is-not-currently-accepting-connections
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/utils/init/postinit.c:377"
reproduced: false
---

# `database "%s" is not currently accepting connections`

## What it means

A connection attempt was refused because the target database is not open for connections right now. The placeholder is the database name. Some databases, such as `template0`, are marked to disallow connections. The server reports it as the object not being in the required state.

## When it happens

It fires when you connect to a database whose `datallowconn` flag is false — most commonly `template0`, or a database temporarily set to reject connections.

## How to fix

Connect to a database that accepts connections. `template0` is deliberately closed; use `template1` or a user database. If you must connect to a closed database temporarily, an administrator can set `datallowconn` to true for it, but leave `template0` as it is.

## Example

*Illustrative* — connecting to template0.

```text
FATAL:  database "template0" is not currently accepting connections
```

## Related

- [database has disappeared from pg_database](./database-has-disappeared-from-pg-database.md)
- [data checksums failed to get enabled in all databases, aborting](./data-checksums-failed-to-get-enabled-in-all-databases-aborting.md)
