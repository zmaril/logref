---
message: "cannot start commands during a parallel operation"
slug: cannot-start-commands-during-a-parallel-operation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_STATE
    code: "25000"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:1146"
reproduced: false
---

# `cannot start commands during a parallel operation`

## What it means

An internal guard fired: a new command was dispatched while the backend was inside a parallel operation. Parallel workers run in a restricted mode that forbids starting fresh commands, so this state should not arise in normal execution.

## When it happens

It is reached from command dispatch when code runs inside parallel mode. It usually points to a function or extension that issues commands from within a parallel plan.

## How to fix

Avoid running command-issuing code in a parallel context. Mark a user-defined function that starts commands as `PARALLEL UNSAFE`, or disable parallelism for the session with `SET max_parallel_workers_per_gather = 0` while investigating.

## Example

*Illustrative* — a command started inside parallel mode.

```text
ERROR:  cannot start commands during a parallel operation
```

## Related

- [cannot take query snapshot during a parallel operation](./cannot-take-query-snapshot-during-a-parallel-operation.md)
- [cannot update SecondarySnapshot during a parallel operation](./cannot-update-secondarysnapshot-during-a-parallel-operation.md)
