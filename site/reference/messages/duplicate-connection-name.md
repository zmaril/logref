---
message: "duplicate connection name"
slug: duplicate-connection-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/contrib/dblink/dblink.c:2580"
reproduced: false
---

# `duplicate connection name`

## What it means

A `dblink` connection was opened with a name that is already in use in the session. The `dblink` extension keeps named connections, and each name must be unique.

## When it happens

It fires from `dblink_connect()` when the connection name argument matches an already-open named connection.

## How to fix

Choose a different connection name, or close the existing one first with `dblink_disconnect('name')`. List open connections with `dblink_get_connections()`.

## Example

*Illustrative* — reusing a dblink connection name.

```sql
SELECT dblink_connect('myconn', 'dbname=remote');
SELECT dblink_connect('myconn', 'dbname=other');  -- duplicate connection name
```

## Related

- [error sending command to database](./error-sending-command-to-database.md)
- [error running query in source server](./error-running-query-in-source-server.md)
