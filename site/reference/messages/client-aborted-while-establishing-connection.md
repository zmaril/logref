---
message: "client %d aborted while establishing connection"
slug: client-aborted-while-establishing-connection
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:3731"
reproduced: false
---

# `client %d aborted while establishing connection`

## What it means

A `pgbench` client could not open its database connection at startup. Without a connection it cannot run any transactions, so it is aborted.

## When it happens

It occurs at the start of a `pgbench` run when connecting fails, for example because of a wrong host or port, exhausted connection slots, or authentication failure.

## How to fix

Verify the connection parameters, that the server is reachable and accepting connections, and that `max_connections` is not exhausted. Correct the connection settings and rerun.

## Example

*Illustrative* — a connection failure at startup.

```text
pgbench: error: client 0 aborted while establishing connection
```

## Related

- [client command no results](./client-command-no-results.md)
- [client aborted in command of script](./client-aborted-in-command-of-script.md)
