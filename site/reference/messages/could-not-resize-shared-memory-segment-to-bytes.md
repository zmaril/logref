---
message: "could not resize shared memory segment \"%s\" to %zu bytes: %m"
slug: could-not-resize-shared-memory-segment-to-bytes
passthrough: false
api: [ereport]
level: [varies]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/storage/ipc/dsm_impl.c:308"
  - "postgres/src/backend/storage/ipc/dsm_impl.c:910"
reproduced: false
---

# `could not resize shared memory segment "%s" to %zu bytes: %m`

## What it means

The server could not resize a dynamic shared-memory segment to the requested size; the errno string gives the operating-system reason.

## When it happens

It arises when a feature that grows a DSM segment (for example parallel query) cannot extend it — commonly because `/dev/shm` or the shared-memory filesystem is out of space.

## Is this a problem?

Check the errno. Free space on the shared-memory filesystem (often `/dev/shm`) or raise its size limit, and review settings that drive parallel-query memory. The affected operation fails until the segment can be sized.

## Example

*Illustrative* — a DSM resize that ran out of space.

```text
ERROR:  could not resize shared memory segment "/PostgreSQL.123456" to 8388608 bytes: No space left on device
```

## Related

- [could not reserve shared memory region (addr=%p) for child %p: error code %lu](./could-not-reserve-shared-memory-region-addr-for-child-error-code.md)
- [cleaning up dynamic shared memory control segment with ID %u](./cleaning-up-dynamic-shared-memory-control-segment-with-id.md)
