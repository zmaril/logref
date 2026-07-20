---
message: "cleaning up dynamic shared memory control segment with ID %u"
slug: cleaning-up-dynamic-shared-memory-control-segment-with-id
passthrough: false
api: [elog]
level: [DEBUG2]
call_sites:
  - "postgres/src/backend/storage/ipc/dsm.c:312"
  - "postgres/src/backend/storage/ipc/dsm.c:416"
reproduced: false
---

# `cleaning up dynamic shared memory control segment with ID %u`

## What it means

A debug trace line reporting that the server is cleaning up a dynamic shared-memory control segment left over from a previous run, identified by its segment id.

## When it happens

It appears at high debug levels during startup, when the server reclaims dynamic-shared-memory state that was not released cleanly (for example after a crash).

## Is this a problem?

No action is needed. Reclaiming an orphaned DSM control segment at startup is normal recovery behavior. The message is visible only at raised debug levels.

## Example

*Illustrative* — cleaning up an old DSM control segment.

```text
DEBUG:  cleaning up dynamic shared memory control segment with ID 1234567
```

## Related

- [could not reserve shared memory region (addr=%p) for child %p: error code %lu](./could-not-reserve-shared-memory-region-addr-for-child-error-code.md)
- [could not resize shared memory segment "%s" to %zu bytes: %m](./could-not-resize-shared-memory-segment-to-bytes.md)
