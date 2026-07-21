---
message: "cannot abort during a parallel operation"
slug: cannot-abort-during-a-parallel-operation
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_STATE
    code: "25000"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:4340"
reproduced: false
---

# `cannot abort during a parallel operation`

## What it means

A transaction abort was attempted from within a parallel operation, where it is not allowed. Parallel workers share transaction state with the leader and cannot independently abort the transaction. It is an internal guard.

## When it happens

It is a can't-happen check reached from parallel query or parallel utility execution and does not arise from ordinary SQL.

## How to fix

There is no user action for normal queries. If a plain parallel query triggered it, capture the query and any extensions that run in parallel workers, and report it as a possible bug.

## Example

*Illustrative* — the parallel-abort guard.

```text
FATAL:  cannot abort during a parallel operation
```

## Related

- [cannot access temporary tables during a parallel operation](./cannot-access-temporary-tables-during-a-parallel-operation.md)
- [can't create a checkpoint during recovery](./can-t-create-a-checkpoint-during-recovery.md)
