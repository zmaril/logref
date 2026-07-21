---
message: "cannot define savepoints during a parallel operation"
slug: cannot-define-savepoints-during-a-parallel-operation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_STATE
    code: "25000"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:4439"
reproduced: false
---

# `cannot define savepoints during a parallel operation`

## What it means

Code tried to define a savepoint while a parallel operation was active. Parallel workers share the leader's transaction and cannot open subtransactions, so savepoints are forbidden in parallel mode.

## When it happens

It occurs when a function invoked during parallel query or a parallel utility issues `SAVEPOINT` or enters a PL/pgSQL exception block.

## How to fix

Avoid savepoints and exception blocks in parallel-executed code. Mark functions that use them as `PARALLEL UNSAFE`, or restructure so subtransactions happen outside the parallel region.

## Example

*Illustrative* — a savepoint in parallel mode.

```text
ERROR:  cannot define savepoints during a parallel operation
```

## Related

- [cannot commit during a parallel operation](./cannot-commit-during-a-parallel-operation.md)
- [cannot delete tuples during a parallel operation](./cannot-delete-tuples-during-a-parallel-operation.md)
