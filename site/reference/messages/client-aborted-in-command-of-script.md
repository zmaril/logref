---
message: "client %d aborted in command %d (%s) of script %d; %s"
slug: client-aborted-in-command-of-script
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:3020"
reproduced: false
---

# `client %d aborted in command %d (%s) of script %d; %s`

## What it means

A `pgbench` client stopped while running a specific command of a script. The message names the command number, the command text, the script, and the underlying error, which explains why the client was aborted.

## When it happens

It occurs during a `pgbench` run when a command in a custom or built-in script fails at execution time.

## How to fix

Read the appended error and the named command to find the failing statement. Fix that command in the script, or address the server-side cause it reports, then rerun.

## Example

*Illustrative* — an aborted command in a script.

```text
pgbench: error: client 0 aborted in command 3 (SQL) of script 0; ERROR:  division by zero
```

## Related

- [client aborted while rolling back the transaction after an error](./client-aborted-while-rolling-back-the-transaction-after-an-error.md)
- [client script aborted in command query](./client-script-aborted-in-command-query.md)
