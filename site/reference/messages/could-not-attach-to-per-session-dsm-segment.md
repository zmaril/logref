---
message: "could not attach to per-session DSM segment"
slug: could-not-attach-to-per-session-dsm-segment
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/common/session.c:169"
reproduced: false
---

# `could not attach to per-session DSM segment`

## What it means

A parallel worker could not attach to the per-session dynamic shared memory (DSM) segment it needs to share state with the leader. Without it, the worker cannot participate. This is an internal error.

## When it happens

It fires during parallel query setup when a worker fails to map the session's DSM segment, possibly due to resource limits or a segment that was already released.

## How to fix

Often this accompanies resource exhaustion or another error that removed the segment. Reduce parallel workers or memory pressure and retry; check `max_connections`/DSM-related limits. If it persists without a clear cause, capture details and report it.

## Example

*Illustrative* — a worker failing to attach to the session DSM.

```text
ERROR:  could not attach to per-session DSM segment
```

## Related

- [could not attach to a SharedFileSet that is already destroyed](./could-not-attach-to-a-sharedfileset-that-is-already-destroyed.md)
- [could not allocate memory for shared memory name](./could-not-allocate-memory-for-shared-memory-name.md)
