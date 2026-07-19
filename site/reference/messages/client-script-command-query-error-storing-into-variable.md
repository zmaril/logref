---
message: "client %d script %d command %d query %d: error storing into variable %s"
slug: client-script-command-query-error-storing-into-variable
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:3351"
reproduced: false
---

# `client %d script %d command %d query %d: error storing into variable %s`

## What it means

A `pgbench` client could not store a query result into a script variable. The message names the script, command, query, and variable involved. The client stops because the variable assignment failed.

## When it happens

It occurs during a `pgbench` run with `\gset` or a similar mechanism when the result cannot be stored, for example because the query returned the wrong number of columns or rows.

## How to fix

Make the query return exactly the shape the variable assignment expects, usually a single row with the named column. Adjust the query or the `\gset` usage in the script, then rerun.

## Example

*Illustrative* — a variable-store failure.

```text
pgbench: error: client 0 script 0 command 1 query 0: error storing into variable x
```

## Related

- [client command no results](./client-command-no-results.md)
- [client script aborted in command query](./client-script-aborted-in-command-query.md)
