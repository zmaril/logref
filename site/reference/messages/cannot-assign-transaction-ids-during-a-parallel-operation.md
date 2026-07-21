---
message: "cannot assign transaction IDs during a parallel operation"
slug: cannot-assign-transaction-ids-during-a-parallel-operation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_STATE
    code: "25000"
call_sites:
  - "postgres/src/backend/access/transam/xact.c:652"
reproduced: false
---

# `cannot assign transaction IDs during a parallel operation`

## What it means

A parallel worker or leader tried to allocate a transaction ID while inside a parallel operation. Parallel workers share the leader's transaction and must not start a new writing transaction, so allocating an XID is forbidden in that context.

## When it happens

It occurs when a function or operation that would perform a write, and therefore need a transaction ID, runs inside a parallel query or parallel utility.

## How to fix

Avoid writes inside parallel-executed code. Mark functions that write as `PARALLEL UNSAFE` so the planner keeps them out of parallel workers, or restructure the work to write outside the parallel region.

## Example

*Illustrative* — a write attempted in a parallel worker.

```text
ERROR:  cannot assign transaction IDs during a parallel operation
```

## Related

- [cannot assign transactionids during a parallel operation](./cannot-assign-transactionids-during-a-parallel-operation.md)
- [cannot change relation mapping in parallel mode](./cannot-change-relation-mapping-in-parallel-mode.md)
