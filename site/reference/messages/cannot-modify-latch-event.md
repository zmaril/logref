---
message: "cannot modify latch event"
slug: cannot-modify-latch-event
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/waiteventset.c:696"
reproduced: false
---

# `cannot modify latch event`

## What it means

An internal guard in the wait-event-set code fired: code tried to modify the latch event of a wait event set. The latch position in a wait set is fixed once created, so changing it is refused.

## When it happens

It is reached when a caller attempts to alter the latch entry of a `WaitEventSet` rather than another socket event. It reflects a coding issue in the caller rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the extension or background-worker code managing the wait event set and report it, since the latch event of a wait set must not be modified.

## Example

*Illustrative* — modifying the latch event of a wait set.

```text
ERROR:  cannot modify latch event
```

## Related

- [cannot modify commandid in active snapshot during a parallel operation](./cannot-modify-commandid-in-active-snapshot-during-a-parallel-operation.md)
- [cannot move a saved cached plan to another context](./cannot-move-a-saved-cached-plan-to-another-context.md)
