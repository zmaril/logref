---
message: "cannot set parameters during a parallel operation"
slug: cannot-set-parameters-during-a-parallel-operation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_STATE
    code: "25000"
call_sites:
  - "postgres/src/backend/utils/misc/guc_funcs.c:54"
reproduced: false
---

# `cannot set parameters during a parallel operation`

## What it means

A `SET` or `RESET` of a configuration parameter was issued while the backend was in a parallel operation. Parallel workers inherit the leader's settings and must not diverge, so changing a parameter during parallel execution is forbidden.

## When it happens

It occurs when procedural code running inside a parallel plan issues `SET` or `RESET` on a GUC parameter.

## How to fix

Change parameters outside parallel operations. Mark functions that call `SET` `PARALLEL UNSAFE` so they do not run in workers, or set the parameter before the parallel query begins.

## Example

*Illustrative* — SET during a parallel operation.

```text
ERROR:  cannot set parameters during a parallel operation
```

## Related

- [cannot release savepoints during a parallel operation](./cannot-release-savepoints-during-a-parallel-operation.md)
- [cannot rollback to savepoints during a parallel operation](./cannot-rollback-to-savepoints-during-a-parallel-operation.md)
