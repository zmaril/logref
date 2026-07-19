---
message: "out of background worker slots"
slug: out-of-background-worker-slots
passthrough: false
api: [ereport]
level: [ERROR, WARNING]
sqlstate:
  - symbol: ERRCODE_CONFIGURATION_LIMIT_EXCEEDED
    code: "53400"
call_sites:
  - "postgres/src/backend/commands/repack.c:3652"
  - "postgres/src/backend/replication/logical/launcher.c:563"
reproduced: false
---

# `out of background worker slots`

## What it means

The server could not register a new background worker because every configured background-worker slot is already in use. The number of slots is fixed at server start.

## When it happens

It surfaces when parallel query, logical replication apply workers, extensions using background workers, or autovacuum-adjacent features try to launch a worker while `max_worker_processes` is exhausted. Parallel query degrades gracefully; some callers report it as a warning.

## How to fix

Raise `max_worker_processes` (and, where relevant, `max_parallel_workers` / `max_parallel_workers_per_gather`) and restart, so more slots exist. If the exhaustion is caused by an extension leaking workers or by heavy parallel-query concurrency, reduce that load or cap parallelism.

## Example

*Illustrative* — a parallel plan launching when all worker slots are taken.

```text
WARNING:  out of background worker slots
```

## Related

- [parallel worker failed to initialize](./parallel-worker-failed-to-initialize.md)
- [too many registered buffers](./too-many-registered-buffers.md)
