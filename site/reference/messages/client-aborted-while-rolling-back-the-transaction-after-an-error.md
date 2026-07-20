---
message: "client %d aborted while rolling back the transaction after an error; %s"
slug: client-aborted-while-rolling-back-the-transaction-after-an-error
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:4211"
reproduced: false
---

# `client %d aborted while rolling back the transaction after an error; %s`

## What it means

A `pgbench` client encountered an error, tried to roll back the transaction, and the rollback itself failed. The appended detail explains the rollback failure. The client is aborted because it cannot return to a clean state.

## When it happens

It occurs during a `pgbench` run after a statement error, when the automatic rollback does not complete, often due to a broken connection.

## How to fix

Look at both the original error and the appended rollback error. A lost connection is a common cause; check server health and the network, fix the failing statement, then rerun.

## Example

*Illustrative* — a failed rollback after an error.

```text
pgbench: error: client 0 aborted while rolling back the transaction after an error; ERROR:  server closed the connection unexpectedly
```

## Related

- [client aborted in command of script](./client-aborted-in-command-of-script.md)
- [client aborted failed to send sql command for rolling back the failed](./client-aborted-failed-to-send-sql-command-for-rolling-back-the-failed.md)
