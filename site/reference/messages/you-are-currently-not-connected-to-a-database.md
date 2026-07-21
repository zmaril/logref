---
message: "You are currently not connected to a database."
slug: you-are-currently-not-connected-to-a-database
passthrough: false
api: [pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_dump.c:1904"
  - "postgres/src/bin/psql/common.c:663"
  - "postgres/src/bin/psql/common.c:720"
  - "postgres/src/bin/psql/common.c:1132"
  - "postgres/src/bin/psql/describe.c:6456"
reproduced: false
---

# `You are currently not connected to a database.`

## What it means

A client tool needs an active database connection to run the requested operation and does not have one. The message comes from tools like `psql` and `pg_dump` when a command that requires a live session is issued while disconnected.

## When it happens

Issuing a meta-command or operation in `psql` after the connection dropped (`\d`, a query) without reconnecting, or a tool reaching a step that needs a connection that was never established or was lost.

## How to fix

Reconnect before running the command. In `psql`, use `\c dbname` (or `\connect`) to open a session; check why the previous connection dropped (server restart, timeout, network). For non-interactive tools, verify the connection parameters and server availability.

## Example

*Illustrative* — a psql command with no live connection.

```text
ERROR:  You are currently not connected to a database.
```

## Related

- [could not establish connection](./could-not-establish-connection.md)
- [connection failure](./connection-failure.md)
