---
message: "cannot establish serializable snapshot during a parallel operation"
slug: cannot-establish-serializable-snapshot-during-a-parallel-operation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/lmgr/predicate.c:1713"
reproduced: false
---

# `cannot establish serializable snapshot during a parallel operation`

## What it means

An internal guard in the predicate-locking code fired: the backend tried to take a fresh serializable snapshot while running inside a parallel operation. A parallel worker shares the leader's serializable snapshot and must not start its own, so this state should not arise in normal execution.

## When it happens

It is reached from serializable isolation bookkeeping when a parallel worker or leader attempts to acquire a serializable snapshot that it should have inherited. It reflects a coding issue in a parallel-aware path rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the query, the isolation level, and the extension or feature that drove the parallel plan, then report it. As a stopgap you can disable parallelism for the session with `SET max_parallel_workers_per_gather = 0`.

## Example

*Illustrative* — a serializable snapshot requested inside parallel mode.

```text
ERROR:  cannot establish serializable snapshot during a parallel operation
```

## Related

- [cannot modify commandid in active snapshot during a parallel operation](./cannot-modify-commandid-in-active-snapshot-during-a-parallel-operation.md)
- [cannot execute during a parallel operation](./cannot-execute-during-a-parallel-operation.md)
