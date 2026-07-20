---
message: "could not open shared memory segment \"%s\": %m"
slug: could-not-open-shared-memory-segment
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/storage/ipc/dsm_impl.c:264"
  - "postgres/src/backend/storage/ipc/dsm_impl.c:721"
  - "postgres/src/backend/storage/ipc/dsm_impl.c:835"
reproduced: false
---

# `could not open shared memory segment "%s": %m`

## What it means

The server could not open a dynamic shared-memory segment by name. It reports the operating-system error. Dynamic shared memory backs parallel query and other cross-process work, and a worker or the leader could not attach to the expected segment.

## When it happens

A parallel worker or a background process tried to open a shared-memory segment that was removed early, never created, or is inaccessible — for example when the dynamic-shared-memory implementation or its backing storage has a problem, or a segment was cleaned up unexpectedly.

## Is this a problem?

Read the system error detail. Check the `dynamic_shared_memory_type` setting and the backing storage it uses (such as `/dev/shm` for the POSIX implementation), ensure it has space and correct permissions, and review the OS logs. If parallel queries trigger it, verify the shared-memory resources the platform provides are adequate.

## Example

*Illustrative* — a failed shared-memory attach.

```text
ERROR:  could not open shared memory segment "/PostgreSQL.12345": No such file or directory
```

## Related

- [could not resize shared memory segment to bytes](./could-not-resize-shared-memory-segment-to-bytes.md)
- [not enough space to serialize guc state](./not-enough-space-to-serialize-guc-state.md)
