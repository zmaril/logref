---
message: "cannot unpin a segment that is not pinned"
slug: cannot-unpin-a-segment-that-is-not-pinned
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/dsm.c:1026"
reproduced: false
---

# `cannot unpin a segment that is not pinned`

## What it means

An internal guard fired in dynamic shared memory bookkeeping: code tried to release a pin on a DSM segment that this backend does not currently hold pinned. Pin and unpin calls must balance, so this state should not occur.

## When it happens

It is reached from DSM reference counting, which parallel query and some extensions use. It reflects a pin-management bug rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the operation, any extensions in use, and the server log, then report it. It points to a bug in the code that manages the segment.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  cannot unpin a segment that is not pinned
```

## Related

- [cannot unpin unknown segment handle](./cannot-unpin-unknown-segment-handle.md)
- [cannot sync without a pendingOps table](./cannot-sync-without-a-pendingops-table.md)
