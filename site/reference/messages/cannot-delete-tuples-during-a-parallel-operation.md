---
message: "cannot delete tuples during a parallel operation"
slug: cannot-delete-tuples-during-a-parallel-operation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_STATE
    code: "25000"
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:2750"
reproduced: false
---

# `cannot delete tuples during a parallel operation`

## What it means

Code tried to delete rows while a parallel operation was active. Parallel workers execute read-only relative to the shared transaction and cannot perform data modifications, so deletes are forbidden in parallel mode.

## When it happens

It occurs when a function invoked during parallel query or a parallel utility issues a `DELETE`.

## How to fix

Keep data-modifying statements out of parallel-executed code. Mark writing functions `PARALLEL UNSAFE`, or perform the delete outside the parallel region.

## Example

*Illustrative* — a delete in parallel mode.

```text
ERROR:  cannot delete tuples during a parallel operation
```

## Related

- [cannot define savepoints during a parallel operation](./cannot-define-savepoints-during-a-parallel-operation.md)
- [cannot commit during a parallel operation](./cannot-commit-during-a-parallel-operation.md)
