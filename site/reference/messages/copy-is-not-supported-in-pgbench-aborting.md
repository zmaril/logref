---
message: "COPY is not supported in pgbench, aborting"
slug: copy-is-not-supported-in-pgbench-aborting
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:3376"
reproduced: false
---

# `COPY is not supported in pgbench, aborting`

## What it means

A `pgbench` custom script issued a `COPY` command. `pgbench` cannot run `COPY` in its script protocol, so the run aborts.

## When it happens

It happens when a `pgbench` script (`-f file`) contains a `COPY` statement.

## How to fix

Remove `COPY` from the `pgbench` script. Prepare data beforehand (for example with a separate `psql \copy` or SQL load step) and have the benchmark script use plain queries instead.

## Example

*Illustrative* — COPY in a pgbench script.

```text
pgbench: error: COPY is not supported in pgbench, aborting
```

## Related

- [condition error in script command](./condition-error-in-script-command.md)
- [COPY data transfer failed](./copy-data-transfer-failed.md)
