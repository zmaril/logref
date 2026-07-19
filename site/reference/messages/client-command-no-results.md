---
message: "client %d command %d: no results"
slug: client-command-no-results
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:3414"
reproduced: false
---

# `client %d command %d: no results`

## What it means

A `pgbench` command that expected a result set received none. A metacommand or query that reads a result, such as one feeding a variable, produced nothing to consume, so the client reports the mismatch.

## When it happens

It occurs during a `pgbench` run when a command that should return rows, for example a `SELECT` used with `\gset`, returns no result at all.

## How to fix

Make the command return a result, or remove the expectation of one. Ensure a query used to set a variable returns exactly one row, and check the script logic around that command.

## Example

*Illustrative* — a command with no results.

```text
pgbench: error: client 0 command 2: no results
```

## Related

- [client script command query error storing into variable](./client-script-command-query-error-storing-into-variable.md)
- [client aborted while establishing connection](./client-aborted-while-establishing-connection.md)
