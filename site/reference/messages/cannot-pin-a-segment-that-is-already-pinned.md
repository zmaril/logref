---
message: "cannot pin a segment that is already pinned"
slug: cannot-pin-a-segment-that-is-already-pinned
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/dsm.c:975"
reproduced: false
---

# `cannot pin a segment that is already pinned`

## What it means

An internal guard in the dynamic-shared-memory code fired: code tried to pin a DSM segment that is already pinned. Pinning keeps a segment alive past the creating session, and pinning it twice is a bookkeeping error.

## When it happens

It is reached when a caller pins a shared-memory segment more than once. It reflects a coding issue in an extension or parallel-infrastructure path rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the extension or feature that manages DSM segments and report it, since a segment must not be pinned twice.

## Example

*Illustrative* — pinning an already-pinned segment.

```text
ERROR:  cannot pin a segment that is already pinned
```

## Related

- [cannot send a message of size via shared memory queue](./cannot-send-a-message-of-size-via-shared-memory-queue.md)
- [cannot request shared memory at this time](./cannot-request-shared-memory-at-this-time.md)
