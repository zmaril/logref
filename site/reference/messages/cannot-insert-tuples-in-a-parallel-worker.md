---
message: "cannot insert tuples in a parallel worker"
slug: cannot-insert-tuples-in-a-parallel-worker
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_STATE
    code: "25000"
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:2212"
reproduced: false
---

# `cannot insert tuples in a parallel worker`

## What it means

A parallel worker tried to insert heap tuples. Parallel workers run in a restricted mode that forbids most writes, so heap inserts from a worker are rejected.

## When it happens

It occurs when a plan runs a data-modifying operation in a parallel worker where it is not permitted — often through a parallel-unsafe function that performs an insert while executing in a worker.

## How to fix

Ensure functions that write data are marked `PARALLEL UNSAFE` so they do not run in workers, or restructure the query so inserts happen in the leader. Disable parallelism for the statement if needed with `SET max_parallel_workers_per_gather = 0`.

## Example

*Illustrative* — an insert from a parallel worker.

```text
ERROR:  cannot insert tuples in a parallel worker
```

## Related

- [cannot modify data in a parallel worker](./cannot-modify-data-in-a-parallel-worker.md)
- [cannot execute during a parallel operation](./cannot-execute-during-a-parallel-operation.md)
