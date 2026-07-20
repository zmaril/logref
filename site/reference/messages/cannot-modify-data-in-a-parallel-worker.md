---
message: "cannot modify data in a parallel worker"
slug: cannot-modify-data-in-a-parallel-worker
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_STATE
    code: "25000"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:843"
reproduced: false
---

# `cannot modify data in a parallel worker`

## What it means

A parallel worker tried to modify data. Parallel workers run in a restricted mode that forbids writes so their changes cannot desynchronize from the leader, so the modification is rejected.

## When it happens

It occurs when a data-changing operation runs inside a parallel worker — commonly through a parallel-unsafe function that performs a write while executing in a worker.

## How to fix

Mark functions that write data as `PARALLEL UNSAFE` so the planner keeps them out of workers, or restructure the query so writes happen in the leader. Turn off parallelism for the statement with `SET max_parallel_workers_per_gather = 0` if needed.

## Example

*Illustrative* — a write from a parallel worker.

```text
ERROR:  cannot modify data in a parallel worker
```

## Related

- [cannot insert tuples in a parallel worker](./cannot-insert-tuples-in-a-parallel-worker.md)
- [cannot execute during a parallel operation](./cannot-execute-during-a-parallel-operation.md)
