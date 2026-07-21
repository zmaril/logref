---
message: "cannot take query snapshot during a parallel operation"
slug: cannot-take-query-snapshot-during-a-parallel-operation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/time/snapmgr.c:306"
reproduced: false
---

# `cannot take query snapshot during a parallel operation`

## What it means

An internal guard fired: code tried to acquire a fresh query snapshot while the backend was inside a parallel operation. Parallel workers inherit the leader's snapshot and must not take their own, so this state should not arise in normal execution.

## When it happens

It is reached from snapshot acquisition when running in parallel mode. It usually points to a function or extension that requests a snapshot from within a parallel plan.

## How to fix

Avoid taking a new snapshot inside a parallel context. Mark a user-defined function that does so as `PARALLEL UNSAFE`, or disable parallelism with `SET max_parallel_workers_per_gather = 0` while investigating.

## Example

*Illustrative* — a snapshot requested inside parallel mode.

```text
ERROR:  cannot take query snapshot during a parallel operation
```

## Related

- [cannot start commands during a parallel operation](./cannot-start-commands-during-a-parallel-operation.md)
- [cannot update SecondarySnapshot during a parallel operation](./cannot-update-secondarysnapshot-during-a-parallel-operation.md)
