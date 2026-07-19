---
message: "could not map shared memory segment \"%s\": %m"
slug: could-not-map-shared-memory-segment
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/storage/ipc/dsm_impl.c:330"
  - "postgres/src/backend/storage/ipc/dsm_impl.c:583"
  - "postgres/src/backend/storage/ipc/dsm_impl.c:742"
  - "postgres/src/backend/storage/ipc/dsm_impl.c:932"
reproduced: false
---

# `could not map shared memory segment "%s": %m`

## What it means

The server could not map a dynamic shared memory (DSM) segment into a process's address space. The placeholders are the segment name and the OS error. DSM segments back parallel query and other cross-process features; a failed mapping means a backend cannot attach to shared state another created.

## When it happens

Resource exhaustion (address space, shared-memory limits, or `/dev/shm` space on Linux with the `posix` DSM implementation), a segment removed out from under the process, or OS-level shared-memory misconfiguration.

## Is this a problem?

Read the appended OS error. On Linux, check free space and limits on `/dev/shm` (the `posix` implementation stores DSM there) and the `dynamic_shared_memory_type` setting. Ensure the OS shared-memory and memory limits are adequate, and that nothing external is deleting the cluster's shared segments. Persistent failures unexplained by resources warrant a bug report with the OS error.

## Example

*Illustrative* — a DSM segment that could not be mapped.

```text
ERROR:  could not map shared memory segment "/PostgreSQL.123": No such file or directory
```

## Related

- [could not unmap shared memory segment](./could-not-unmap-shared-memory-segment.md)
- [could not attach to dynamic shared area](./could-not-attach-to-dynamic-shared-area.md)
