---
message: "%s() failed: %m"
slug: failed-f29774
passthrough: false
api: [ereport, pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/libpq/pqcomm.c:193"
  - "postgres/src/backend/storage/ipc/waiteventset.c:781"
  - "postgres/src/backend/storage/ipc/waiteventset.c:961"
  - "postgres/src/backend/storage/ipc/waiteventset.c:1203"
  - "postgres/src/backend/storage/ipc/waiteventset.c:1365"
  - "postgres/src/backend/storage/ipc/waiteventset.c:1491"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:434"
  - "postgres/src/bin/pg_basebackup/receivelog.c:924"
  - "postgres/src/bin/pg_dump/parallel.c:1609"
  - "postgres/src/bin/pg_upgrade/parallel.c:297"
  - "postgres/src/bin/pg_upgrade/task.c:406"
  - "postgres/src/bin/pgbench/pgbench.c:7711"
reproduced: false
---

# `%s() failed: %m`

## What it means

A named function call failed, reported with the function name and the OS error. The placeholder is the function name; `%m` is the `errno` text. It is the no-argument variant of the `%s(%s) failed: %m` shape, used across client tools and the backend to report a failing system/library call.

## When it happens

A wide range of low-level failures — a `fork`, `pipe`, `socket`, cryptographic, or other library call returning an error — in the postmaster, parallel workers, `pgbench`, or logical-replication tools. The `%m` gives the specific reason.

## How to fix

Read the named function and `%m`. Resource-exhaustion errors (`Cannot allocate memory`, `Resource temporarily unavailable`) point at OS limits — check ulimits and system load. Others are specific to the call; use the function name to narrow which subsystem failed and address the `errno` cause.

## Example

*Illustrative* — a fork failure under resource pressure.

```text
FATAL:  fork() failed: Resource temporarily unavailable
```

## Related

- [%s(%s) failed: %m](./failed-6aec9d.md)
- [out of memory](./out-of-memory-6bf5c2.md)
