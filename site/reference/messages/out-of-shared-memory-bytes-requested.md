---
message: "out of shared memory (%zu bytes requested)"
slug: out-of-shared-memory-bytes-requested
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OUT_OF_MEMORY
    code: "53200"
call_sites:
  - "postgres/src/backend/storage/ipc/shmem.c:673"
  - "postgres/src/backend/storage/ipc/shmem.c:770"
reproduced: false
---

# `out of shared memory (%zu bytes requested)`

## What it means

A request to allocate memory from the server's fixed shared-memory area could not be satisfied because not enough contiguous space remained. The placeholder is the number of bytes requested.

## When it happens

It appears when a feature backed by shared memory — the lock table, predicate locks, some extensions, or dynamic shared-memory consumers — needs more space than the segment sized at startup can provide.

## How to fix

Increase the setting that governs the exhausted structure (often `max_locks_per_transaction`, `max_pred_locks_per_transaction`, `max_connections`, or an extension's own sizing GUC) and restart so the shared segment is sized larger. If a single session is consuming an outsize share (for example holding a huge number of locks), address that workload.

## Example

*Illustrative* — a shared-memory allocation that the segment could not satisfy.

```text
ERROR:  out of shared memory (1048576 bytes requested)
```

## Related

- [out of shared memory](./out-of-shared-memory.md)
- [out of background worker slots](./out-of-background-worker-slots.md)
