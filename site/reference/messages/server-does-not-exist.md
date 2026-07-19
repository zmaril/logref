---
message: "server \"%s\" does not exist"
slug: server-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:1938"
  - "postgres/src/backend/commands/foreigncmds.c:439"
  - "postgres/src/backend/commands/foreigncmds.c:1097"
  - "postgres/src/backend/commands/foreigncmds.c:1460"
  - "postgres/src/backend/foreign/foreign.c:743"
reproduced: false
---

# `server "%s" does not exist`

## What it means

A command referenced a foreign server by name that is not defined. The placeholder is the server name. Foreign servers live in `pg_foreign_server` and are created with `CREATE SERVER`; referring to one that does not exist produces this.

## When it happens

Running `CREATE USER MAPPING`, `CREATE FOREIGN TABLE`, `ALTER SERVER`, or `IMPORT FOREIGN SCHEMA` naming a server that was never created, was dropped, or is misspelled.

## How to fix

List foreign servers with `\des` in psql or `SELECT srvname FROM pg_foreign_server`. Create the server first with `CREATE SERVER ... FOREIGN DATA WRAPPER ...`, or correct the name to an existing one.

## Example

*Illustrative* — a user mapping for a missing server.

```sql
CREATE USER MAPPING FOR app SERVER no_such_server OPTIONS (user 'u');
```

## Related

- [subscription does not exist](./subscription-does-not-exist.md)
- [access method does not exist](./access-method-does-not-exist.md)
