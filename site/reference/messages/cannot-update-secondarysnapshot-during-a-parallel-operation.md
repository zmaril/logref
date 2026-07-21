---
message: "cannot update SecondarySnapshot during a parallel operation"
slug: cannot-update-secondarysnapshot-during-a-parallel-operation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/time/snapmgr.c:361"
reproduced: false
---

# `cannot update SecondarySnapshot during a parallel operation`

## What it means

An internal guard fired: code tried to change the backend's secondary snapshot while inside a parallel operation. Parallel workers share the leader's snapshots and must not alter them, so this state should not arise in normal execution.

## When it happens

It is reached from snapshot management when running in parallel mode. It usually points to a function or extension that changes snapshots from within a parallel plan.

## How to fix

Avoid altering snapshots inside a parallel context. Mark a user-defined function that does so as `PARALLEL UNSAFE`, or disable parallelism with `SET max_parallel_workers_per_gather = 0` while investigating.

## Example

*Illustrative* — a snapshot change inside parallel mode.

```text
ERROR:  cannot update SecondarySnapshot during a parallel operation
```

## Related

- [cannot take query snapshot during a parallel operation](./cannot-take-query-snapshot-during-a-parallel-operation.md)
- [cannot start commands during a parallel operation](./cannot-start-commands-during-a-parallel-operation.md)
