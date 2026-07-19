---
message: "client %d aborted while receiving the transaction status"
slug: client-aborted-while-receiving-the-transaction-status
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:4166"
  - "postgres/src/bin/pgbench/pgbench.c:4301"
reproduced: false
---

# `client %d aborted while receiving the transaction status`

## What it means

A `pgbench` client gave up while waiting to receive the transaction status from the server. The placeholder is the client number. This is a benchmarking-tool message, not a server error — the client's connection or the server became unresponsive mid-transaction.

## When it happens

Running `pgbench` when a backend connection is lost, the server is overloaded and stops responding, or a network interruption occurs while the client awaits a transaction result.

## How to fix

Check whether the server is healthy and not overloaded under the benchmark's concurrency, and look for connection drops or timeouts in the server log. Reduce client count or fix the connectivity issue, then re-run. The message reflects the benchmark client's view, not a data problem.

## Example

*Illustrative* — a pgbench client losing its connection.

```text
client 4 aborted while receiving the transaction status
```

## Related

- [client aborted while rolling back the transaction after an error; perhaps the backend died while processing](./client-aborted-while-rolling-back-the-transaction-after-an-error-perhaps-the.md)
- [client script command query expected one row got](./client-script-command-query-expected-one-row-got.md)
