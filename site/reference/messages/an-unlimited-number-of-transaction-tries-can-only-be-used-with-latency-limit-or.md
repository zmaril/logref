---
message: "an unlimited number of transaction tries can only be used with --latency-limit or a duration (-T)"
slug: an-unlimited-number-of-transaction-tries-can-only-be-used-with-latency-limit-or
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:7292"
reproduced: false
---

# `an unlimited number of transaction tries can only be used with --latency-limit or a duration (-T)`

## What it means

A benchmark run asked for an unlimited number of transaction retries, but retries with no cap only make sense when paired with a stopping condition such as a latency limit or a fixed duration.

## When it happens

It occurs in `pgbench` when `--max-tries=0` (unlimited) is set without `--latency-limit` or a duration (`-T`), leaving no bound on retrying.

## How to fix

Add a `--latency-limit` or run for a fixed duration with `-T` when using unlimited retries, or set a finite `--max-tries`. One of these must bound the retry loop so the run can terminate.

## Example

*Illustrative* — unlimited retries with no stopping condition.

```text
an unlimited number of transaction tries can only be used with --latency-limit or a duration (-T)
```

## Related

- [at most SQL scripts are allowed](./at-most-sql-scripts-are-allowed.md)
- [-1 can only be used in non-interactive mode](./1-can-only-be-used-in-non-interactive-mode.md)
