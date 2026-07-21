---
message: "client %d aborted: failed to send sql command for rolling back the failed transaction"
slug: client-aborted-failed-to-send-sql-command-for-rolling-back-the-failed
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:4145"
reproduced: false
---

# `client %d aborted: failed to send sql command for rolling back the failed transaction`

## What it means

A `pgbench` client tried to send a rollback command after a transaction failed but the send itself did not succeed. Unable to clean up the transaction, the client is aborted.

## When it happens

It occurs during a `pgbench` run after a query error, when the follow-up rollback cannot be delivered, often because the connection is broken.

## How to fix

Investigate the connection loss that prevented the rollback, along with the original query error that triggered it. Address both the failing query and the connection stability, then rerun.

## Example

*Illustrative* — a failed rollback send.

```text
pgbench: error: client 0 aborted: failed to send sql command for rolling back the failed transaction
```

## Related

- [client aborted failed to exit pipeline mode for rolling back the failed](./client-aborted-failed-to-exit-pipeline-mode-for-rolling-back-the-failed.md)
- [client aborted while rolling back the transaction after an error](./client-aborted-while-rolling-back-the-transaction-after-an-error.md)
