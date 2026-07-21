---
message: "invalid message received from worker: \"%s\""
slug: invalid-message-received-from-worker
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/parallel.c:1189"
  - "postgres/src/bin/pg_dump/parallel.c:1427"
reproduced: false
---

# `invalid message received from worker: "%s"`

## What it means

Internal error. A leader process received a message from a background/parallel worker that it could not interpret. The placeholder shows the offending content. It is a consistency guard over leader/worker communication.

## When it happens

It fires in parallel query, parallel maintenance, or logical replication apply when a worker's message on the shared queue is malformed. Ordinary operation does not surface it; it points to an internal bug or memory corruption.

## How to fix

This is a can't-happen guard. If parallel query triggers it, disabling parallelism (`SET max_parallel_workers_per_gather = 0`) is a workaround. Capture the workload and report a reproducible case; investigate host memory if other corruption appears.

## Example

*Illustrative* — an unreadable message from a worker.

```text
FATAL:  invalid message received from worker: "garbage"
```

## Related

- [lost connection to the logical replication parallel apply worker](./lost-connection-to-the-logical-replication-parallel-apply-worker.md)
- [invalid processing mode in background worker](./invalid-processing-mode-in-background-worker.md)
