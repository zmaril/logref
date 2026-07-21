---
message: "could not stat shared memory segment \"%s\": %m"
slug: could-not-stat-shared-memory-segment
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/storage/ipc/dsm_impl.c:289"
  - "postgres/src/backend/storage/ipc/dsm_impl.c:562"
  - "postgres/src/backend/storage/ipc/dsm_impl.c:766"
  - "postgres/src/backend/storage/ipc/dsm_impl.c:859"
reproduced: false
---

# `could not stat shared memory segment "%s": %m`

## What it means

The server could not `stat()` a dynamic shared memory segment — a call it uses to check a segment's size or existence. The placeholders are the segment name and the OS error. A failed `stat` means the backing object could not be examined, usually because it is missing or inaccessible.

## When it happens

The DSM segment was removed or never fully created, permissions on the backing store changed, or (on the `posix` implementation) the `/dev/shm` object was altered by something outside Postgres.

## Is this a problem?

Read the appended OS error. Confirm the shared-memory backing store is healthy: adequate `/dev/shm` space and permissions on Linux, correct `dynamic_shared_memory_type`, and no external interference with the cluster's segments. Transient cases around backend exit are usually harmless; persistent ones point to a misconfigured or contended shared-memory area.

## Example

*Illustrative* — a DSM segment that could not be stat'd.

```text
ERROR:  could not stat shared memory segment "/PostgreSQL.123": No such file or directory
```

## Related

- [could not map shared memory segment](./could-not-map-shared-memory-segment.md)
- [could not remove shared memory segment](./could-not-remove-shared-memory-segment.md)
