---
message: "cannot unpin unknown segment handle"
slug: cannot-unpin-unknown-segment-handle
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/dsm.c:1024"
reproduced: false
---

# `cannot unpin unknown segment handle`

## What it means

An internal guard fired in dynamic shared memory bookkeeping: code tried to unpin a DSM segment identified by a handle the backend does not know. The handle does not correspond to any tracked segment, so the unpin cannot proceed.

## When it happens

It is reached from DSM reference counting used by parallel query and some extensions. It reflects a handle-management bug rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the operation, any extensions in use, and the server log, then report it. It points to a bug in the code that tracks the segment handle.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  cannot unpin unknown segment handle
```

## Related

- [cannot unpin a segment that is not pinned](./cannot-unpin-a-segment-that-is-not-pinned.md)
- [cannot sync without a pendingOps table](./cannot-sync-without-a-pendingops-table.md)
