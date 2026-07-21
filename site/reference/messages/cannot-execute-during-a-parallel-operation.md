---
message: "cannot execute %s during a parallel operation"
slug: cannot-execute-during-a-parallel-operation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_STATE
    code: "25000"
call_sites:
  - "postgres/src/backend/tcop/utility.c:430"
reproduced: false
---

# `cannot execute %s during a parallel operation`

## What it means

A utility command that is not safe to run inside a parallel operation was issued while the backend was in parallel mode. The named command would write data or change state that parallel workers cannot coordinate, so it is blocked. The placeholder is the command name.

## When it happens

It occurs when a function or procedure running inside a parallel plan issues a command such as a DDL statement or a data change. Parallel workers run in a restricted mode that forbids these commands.

## How to fix

Move the command out of the parallel context. If a user-defined function performs writes or DDL, mark it `PARALLEL UNSAFE` so the planner does not run it in a parallel worker, or restructure the query so the command runs on its own.

## Example

*Illustrative* — a write attempted inside a parallel plan.

```text
ERROR:  cannot execute UPDATE during a parallel operation
```

## Related

- [cannot modify data in a parallel worker](./cannot-modify-data-in-a-parallel-worker.md)
- [cannot insert tuples in a parallel worker](./cannot-insert-tuples-in-a-parallel-worker.md)
