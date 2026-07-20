---
message: "client %d script %d command %d query %d: expected one row, got %d"
slug: client-script-command-query-expected-one-row-got
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:3311"
  - "postgres/src/bin/pgbench/pgbench.c:3326"
reproduced: false
---

# `client %d script %d command %d query %d: expected one row, got %d`

## What it means

A `pgbench` script used a command that requires a single-row result (such as `\gset`) but the query returned a different number of rows. The placeholders identify the client, script, command, and the actual row count. It is a benchmark-script error, not a server fault.

## When it happens

Running a custom `pgbench` script whose `\gset` (or similar) query returns zero rows or more than one row, so the tool cannot bind the expected single-row result to variables.

## How to fix

Adjust the script's query to return exactly one row — add a `LIMIT 1`, tighten the `WHERE`, or use an aggregate — so `\gset` has a single row to capture. Verify the query against the benchmark's data before running at scale.

## Example

*Illustrative* — a \gset query returning several rows.

```text
client 0 script 0 command 3 query 0: expected one row, got 5
```

## Related

- [client aborted while receiving the transaction status](./client-aborted-while-receiving-the-transaction-status.md)
- [client aborted while rolling back the transaction after an error; perhaps the backend died while processing](./client-aborted-while-rolling-back-the-transaction-after-an-error-perhaps-the.md)
