---
message: "cannot sync without a pendingOps table"
slug: cannot-sync-without-a-pendingops-table
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/sync/sync.c:309"
reproduced: false
---

# `cannot sync without a pendingOps table`

## What it means

An internal guard fired in the checkpointer's file-sync bookkeeping: a request to process the pending-operations table arrived when that table was not set up. The pending-ops table is created during startup, so this state should not occur in normal running.

## When it happens

It is reached from the fsync-request machinery, which the checkpointer owns. It reflects an internal ordering issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the server log around the message and the events that preceded it, then report it. It points to a bug in the sync-request setup.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  cannot sync without a pendingOps table
```

## Related

- [cannot take over tapes before all workers finish](./cannot-take-over-tapes-before-all-workers-finish.md)
- [cannot unpin unknown segment handle](./cannot-unpin-unknown-segment-handle.md)
