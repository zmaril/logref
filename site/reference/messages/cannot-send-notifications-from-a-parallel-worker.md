---
message: "cannot send notifications from a parallel worker"
slug: cannot-send-notifications-from-a-parallel-worker
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/async.c:903"
reproduced: false
---

# `cannot send notifications from a parallel worker`

## What it means

An internal guard fired: a parallel worker tried to queue an asynchronous notification. `NOTIFY` state is managed by the leader, so a worker cannot send notifications.

## When it happens

It is reached when a `NOTIFY` runs inside a parallel worker — usually through a parallel-unsafe function that calls `pg_notify()` while executing in a worker. It reflects that the function should not be running in parallel.

## How to fix

Mark functions that send notifications `PARALLEL UNSAFE` so they run only in the leader, or move the `NOTIFY` out of parallel execution. Disable parallelism for the statement with `SET max_parallel_workers_per_gather = 0` if needed.

## Example

*Illustrative* — NOTIFY from a parallel worker.

```text
ERROR:  cannot send notifications from a parallel worker
```

## Related

- [cannot PREPARE a transaction that has executed LISTEN, UNLISTEN, or NOTIFY](./cannot-prepare-a-transaction-that-has-executed-listen-unlisten-or-notify.md)
- [cannot modify data in a parallel worker](./cannot-modify-data-in-a-parallel-worker.md)
