---
message: "error sending command to database \"%s\": %s"
slug: error-sending-command-to-database
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:939"
reproduced: false
---

# `error sending command to database "%s": %s`

## What it means

`pg_amcheck` failed to send a check command to a database over its connection. The placeholders are the database name and the error. The command could not be dispatched.

## When it happens

It fires in `pg_amcheck` while issuing verification queries in parallel, when sending a command to one of the connections fails — a dropped connection or a server fault.

## How to fix

Check the reported error and the server log. Confirm the server is up and reachable and that the connection did not drop under load. Reducing `pg_amcheck`'s parallelism (`-j`) can help if the server is resource-constrained.

## Example

*Illustrative* — a command-send failure.

```text
pg_amcheck: error: error sending command to database "mydb": ...
```

## Related

- [error running query on source server](./error-running-query-on-source-server.md)
- [duplicate connection name](./duplicate-connection-name.md)
