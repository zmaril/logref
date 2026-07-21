---
message: "connection failure: %s"
slug: connection-failure
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/task.c:218"
  - "postgres/src/bin/pg_upgrade/task.c:269"
  - "postgres/src/bin/pg_upgrade/task.c:284"
  - "postgres/src/bin/pg_upgrade/task.c:295"
reproduced: false
---

# `connection failure: %s`

## What it means

A tool (here `pg_upgrade`) could not connect to a database server it needs. The placeholder is the underlying connection error text. Without the connection the tool cannot proceed and stops at `FATAL`.

## When it happens

Running a tool that connects internally — like `pg_upgrade` starting the old or new server — when the server is not reachable: not started, wrong socket/port, authentication rejected, or the temporary server failed to launch.

## How to fix

Read the included error text for the specific cause. For `pg_upgrade`, ensure both clusters' binaries and data directories are correct and that the tool can start the servers (check the per-cluster logs it leaves behind). Verify sockets/ports are free and authentication permits the local connection.

## Example

*Illustrative* — a tool unable to connect.

```text
FATAL:  connection failure: connection to server failed
```

## Related

- [could not establish connection](./could-not-establish-connection.md)
- [you are currently not connected to a database](./you-are-currently-not-connected-to-a-database.md)
