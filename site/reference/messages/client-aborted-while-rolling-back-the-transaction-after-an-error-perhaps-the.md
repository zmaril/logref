---
message: "client %d aborted while rolling back the transaction after an error; perhaps the backend died while processing"
slug: client-aborted-while-rolling-back-the-transaction-after-an-error-perhaps-the
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:3550"
  - "postgres/src/bin/pgbench/pgbench.c:4182"
reproduced: false
---

# `client %d aborted while rolling back the transaction after an error; perhaps the backend died while processing`

## What it means

A `pgbench` client failed to roll back a transaction after an earlier error, and the tool suspects the backend died while processing. The placeholder is the client number. It is a benchmarking-tool diagnostic pointing at a lost or crashed backend connection.

## When it happens

During a `pgbench` run when a backend terminates unexpectedly (a crash, an out-of-memory kill, or a forced disconnect) so the client's rollback cannot complete.

## How to fix

Investigate why the backend went away: check the server log for a crash, an OOM killer entry, or an administrative termination, and confirm the server survived the benchmark load. Address the underlying failure, then re-run the benchmark.

## Example

*Illustrative* — a pgbench client after a backend crash.

```text
client 2 aborted while rolling back the transaction after an error; perhaps the backend died while processing
```

## Related

- [client aborted while receiving the transaction status](./client-aborted-while-receiving-the-transaction-status.md)
- [client script command query expected one row got](./client-script-command-query-expected-one-row-got.md)
