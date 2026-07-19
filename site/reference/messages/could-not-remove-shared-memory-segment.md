---
message: "could not remove shared memory segment \"%s\": %m"
slug: could-not-remove-shared-memory-segment
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/storage/ipc/dsm_impl.c:240"
  - "postgres/src/backend/storage/ipc/dsm_impl.c:546"
  - "postgres/src/backend/storage/ipc/dsm_impl.c:650"
  - "postgres/src/backend/storage/ipc/dsm_impl.c:821"
reproduced: false
---

# `could not remove shared memory segment "%s": %m`

## What it means

The server could not remove (unlink) a dynamic shared memory segment it had created. The placeholders are the segment name and the OS error. DSM segments are cleaned up when no longer needed; a failed removal can leave an orphaned segment consuming shared-memory space.

## When it happens

The segment was already gone, permissions changed, or the shared-memory backing store is in an unexpected state — for example a `/dev/shm` file deleted or altered by something outside Postgres on the `posix` implementation.

## Is this a problem?

Read the appended OS error. Usually harmless in isolation, but if orphaned segments accumulate (visible under `/dev/shm` for the `posix` type), they can exhaust shared-memory space; a clean cluster restart removes leftovers. Make sure no external process or cleanup job is interfering with the cluster's shared-memory files.

## Example

*Illustrative* — a DSM segment that could not be unlinked.

```text
LOG:  could not remove shared memory segment "/PostgreSQL.123": No such file or directory
```

## Related

- [could not map shared memory segment](./could-not-map-shared-memory-segment.md)
- [could not stat shared memory segment](./could-not-stat-shared-memory-segment.md)
