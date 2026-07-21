---
message: "cannot commit during a parallel operation"
slug: cannot-commit-during-a-parallel-operation
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_STATE
    code: "25000"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:4217"
reproduced: false
---

# `cannot commit during a parallel operation`

## What it means

Code tried to commit the transaction while a parallel operation was still active. Parallel workers run under the leader's transaction, so the transaction cannot commit until parallel mode has ended. Reaching commit while parallel work is in flight is an invalid transaction state.

## When it happens

It occurs when a routine invoked during parallel query or a parallel utility attempts transaction control, such as a `COMMIT` inside a procedure that ran in a parallel context.

## How to fix

Do not issue commits from code that runs inside a parallel operation. Mark functions that perform transaction control as `PARALLEL UNSAFE`, or restructure so the commit happens outside the parallel region.

## Example

*Illustrative* — a commit during parallel work.

```text
FATAL:  cannot commit during a parallel operation
```

## Related

- [cannot commit while a portal is pinned](./cannot-commit-while-a-portal-is-pinned.md)
- [cannot commit while a subtransaction is active](./cannot-commit-while-a-subtransaction-is-active.md)
