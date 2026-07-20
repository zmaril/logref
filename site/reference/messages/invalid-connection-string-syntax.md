---
message: "invalid connection string syntax: %s"
slug: invalid-connection-string-syntax
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:309"
  - "postgres/src/backend/replication/libpqwalreceiver/libpqwalreceiver.c:500"
reproduced: false
---

# `invalid connection string syntax: %s`

## What it means

A connection string could not be parsed. The placeholder shows the part that failed. Postgres accepts either keyword/value pairs or a URI, and the given text matches neither.

## When it happens

It arises where the server or a tool parses a connection string — for example `postgres_fdw` or `dblink` server options, or a replication `primary_conninfo` — when the string is malformed: an unbalanced quote, a stray character, or a bad URI.

## How to fix

Fix the connection string to valid `key=value` form (for example `host=db1 port=5432 dbname=app`) or a valid `postgresql://` URI. Quote values that contain spaces with single quotes, and escape embedded quotes. Test it with `psql` before storing it.

## Example

*Illustrative* — a malformed connection string.

```text
ERROR:  invalid connection string syntax: host=db1 port
```

## Related

- [invalid parameter list format](./invalid-parameter-list-format.md)
- [invalid response from primary server](./invalid-response-from-primary-server.md)
