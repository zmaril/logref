---
message: "cannot modify commandid in active snapshot during a parallel operation"
slug: cannot-modify-commandid-in-active-snapshot-during-a-parallel-operation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/time/snapmgr.c:764"
reproduced: false
---

# `cannot modify commandid in active snapshot during a parallel operation`

## What it means

An internal guard fired: code tried to change the command id recorded in the active snapshot while running inside a parallel operation. The snapshot is shared read-only among parallel workers, so its command id must not be modified. The state should not arise in normal execution.

## When it happens

It is reached when a parallel-mode code path attempts to advance the command id of a shared snapshot. It reflects a coding issue in a parallel-aware path rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the query and the feature that drove the parallel plan and report it. Disabling parallelism with `SET max_parallel_workers_per_gather = 0` can serve as a stopgap.

## Example

*Illustrative* — a command-id change in a shared snapshot.

```text
ERROR:  cannot modify commandid in active snapshot during a parallel operation
```

## Related

- [cannot establish serializable snapshot during a parallel operation](./cannot-establish-serializable-snapshot-during-a-parallel-operation.md)
- [cannot modify data in a parallel worker](./cannot-modify-data-in-a-parallel-worker.md)
