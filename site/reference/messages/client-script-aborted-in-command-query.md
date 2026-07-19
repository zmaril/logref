---
message: "client %d script %d aborted in command %d query %d: %s"
slug: client-script-aborted-in-command-query
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:3401"
reproduced: false
---

# `client %d script %d aborted in command %d query %d: %s`

## What it means

A `pgbench` client stopped at a specific query within a command of a script. The message names the script, command, and query numbers along with the error, which explains why the client was aborted.

## When it happens

It occurs during a `pgbench` run when a query inside a multi-query command fails at execution time.

## How to fix

Use the named script, command, and query numbers to locate the failing statement, and read the appended error. Fix that query or the condition it reports, then rerun.

## Example

*Illustrative* — an aborted query in a script.

```text
pgbench: error: client 0 script 0 aborted in command 1 query 0: ERROR:  relation "t" does not exist
```

## Related

- [client aborted in command of script](./client-aborted-in-command-of-script.md)
- [client script command query error storing into variable](./client-script-command-query-error-storing-into-variable.md)
