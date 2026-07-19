---
message: "cannot release savepoints during a parallel operation"
slug: cannot-release-savepoints-during-a-parallel-operation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_STATE
    code: "25000"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:4526"
reproduced: false
---

# `cannot release savepoints during a parallel operation`

## What it means

A `RELEASE SAVEPOINT` was issued while the backend was in a parallel operation. Parallel workers share the leader's transaction state and cannot participate in changing the savepoint stack, so releasing a savepoint is forbidden in parallel mode.

## When it happens

It occurs when procedural code running inside a parallel plan issues `RELEASE SAVEPOINT`.

## How to fix

Manage savepoints outside parallel operations. Mark functions that alter transaction state `PARALLEL UNSAFE` so they do not run in parallel workers, or restructure so savepoint changes happen in the leader outside parallel mode.

## Example

*Illustrative* — releasing a savepoint in parallel mode.

```text
ERROR:  cannot release savepoints during a parallel operation
```

## Related

- [cannot rollback to savepoints during a parallel operation](./cannot-rollback-to-savepoints-during-a-parallel-operation.md)
- [cannot set parameters during a parallel operation](./cannot-set-parameters-during-a-parallel-operation.md)
