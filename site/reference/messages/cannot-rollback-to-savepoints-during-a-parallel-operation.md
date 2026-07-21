---
message: "cannot rollback to savepoints during a parallel operation"
slug: cannot-rollback-to-savepoints-during-a-parallel-operation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_STATE
    code: "25000"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:4635"
reproduced: false
---

# `cannot rollback to savepoints during a parallel operation`

## What it means

A `ROLLBACK TO SAVEPOINT` was issued while the backend was in a parallel operation. Parallel workers share the leader's transaction state and cannot take part in unwinding the savepoint stack, so rolling back to a savepoint is forbidden in parallel mode.

## When it happens

It occurs when procedural code running inside a parallel plan issues `ROLLBACK TO SAVEPOINT`.

## How to fix

Manage savepoints outside parallel operations. Mark functions that alter transaction state `PARALLEL UNSAFE`, or restructure so savepoint rollbacks happen in the leader outside parallel mode.

## Example

*Illustrative* — rollback to savepoint in parallel mode.

```text
ERROR:  cannot rollback to savepoints during a parallel operation
```

## Related

- [cannot release savepoints during a parallel operation](./cannot-release-savepoints-during-a-parallel-operation.md)
- [cannot set parameters during a parallel operation](./cannot-set-parameters-during-a-parallel-operation.md)
