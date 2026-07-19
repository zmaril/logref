---
message: "entry ref vanished before deletion"
slug: entry-ref-vanished-before-deletion
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/activity/pgstat_shmem.c:681"
reproduced: false
---

# `entry ref vanished before deletion`

## What it means

An internal guard in the cumulative statistics subsystem. A shared statistics entry that code held a reference to disappeared before it could be deleted. This is a "can't happen" consistency check on shared stats state.

## When it happens

It fires in the shared-memory statistics machinery when a reference-counted entry is released concurrently in an unexpected order, pointing at an internal bug rather than user action.

## How to fix

This is not a user-facing condition. If it recurs, capture the log context and server version and report it to the PostgreSQL developers. It does not indicate a problem with any particular query.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  entry ref vanished before deletion
```

## Related

- [EmitConnectionWarnings() called more than once](./emitconnectionwarnings-called-more-than-once.md)
- [duplicate entry found while reassigning a prepared transaction's locks](./duplicate-entry-found-while-reassigning-a-prepared-transaction-s-locks.md)
