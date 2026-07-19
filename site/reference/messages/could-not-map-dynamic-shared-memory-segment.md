---
message: "could not map dynamic shared memory segment"
slug: could-not-map-dynamic-shared-memory-segment
passthrough: false
api: [elog, ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/contrib/pg_prewarm/autoprewarm.c:516"
  - "postgres/src/backend/access/transam/parallel.c:1354"
  - "postgres/src/backend/commands/repack_worker.c:76"
  - "postgres/src/backend/replication/logical/applyparallelworker.c:907"
  - "postgres/src/backend/storage/ipc/dsm_registry.c:257"
reproduced: false
---

# `could not map dynamic shared memory segment`

## What it means

A backend could not attach to a dynamic shared-memory (DSM) segment that another process created — for example the shared state a parallel query or an extension like `pg_prewarm` uses. Without the mapping the participating process cannot join the shared work.

## When it happens

Parallel query workers or background workers attaching to a DSM segment, when the segment was already destroyed, the process hit a shared-memory resource limit, or the OS refused the mapping. It can also appear if `dynamic_shared_memory_type` is misconfigured for the platform.

## How to fix

Check operating-system shared-memory limits and available memory; exhaustion is the common cause under heavy parallelism. Confirm `dynamic_shared_memory_type` is appropriate for the platform. If it comes from an extension's background worker, that worker may have torn down the segment early. Reducing parallelism can work around resource pressure.

## Example

*Illustrative* — a worker failing to attach to shared memory.

```text
ERROR:  could not map dynamic shared memory segment
```

## Related

- [could not receive data from WAL stream](./could-not-receive-data-from-wal-stream.md)
- [requested length too large](./requested-length-too-large.md)
