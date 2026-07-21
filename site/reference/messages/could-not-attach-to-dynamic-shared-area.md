---
message: "could not attach to dynamic shared area"
slug: could-not-attach-to-dynamic-shared-area
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/utils/mmgr/dsa.c:521"
  - "postgres/src/backend/utils/mmgr/dsa.c:1072"
  - "postgres/src/backend/utils/mmgr/dsa.c:1412"
reproduced: false
---

# `could not attach to dynamic shared area`

## What it means

A backend could not attach to a dynamic shared area (DSA) — a shared-memory allocator region used by parallel query and other cross-process features. The placeholder-free message means the process failed to map or join the DSA another backend set up.

## When it happens

Shared-memory resource exhaustion, a DSM segment removed or unavailable, or an OS-level shared-memory misconfiguration during a parallel operation.

## How to fix

Look for an accompanying shared-memory error that names the underlying cause (mapping/allocation failure). Ensure `/dev/shm` and OS shared-memory limits are adequate for your parallelism and that `dynamic_shared_memory_type` is set appropriately. Reducing `max_parallel_workers_per_gather` lowers demand if resources are tight. Persistent, unexplained failures warrant a report.

## Example

*Illustrative* — a backend failing to join a shared area.

```text
ERROR:  could not attach to dynamic shared area
```

## Related

- [could not map shared memory segment](./could-not-map-shared-memory-segment.md)
- [could not create worker process](./could-not-create-worker-process.md)
