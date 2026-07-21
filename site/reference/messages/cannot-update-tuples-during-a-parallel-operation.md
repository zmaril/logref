---
message: "cannot update tuples during a parallel operation"
slug: cannot-update-tuples-during-a-parallel-operation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_STATE
    code: "25000"
call_sites:
  - "postgres/src/backend/access/heap/heapam.c:3262"
  - "postgres/src/backend/access/index/genam.c:830"
reproduced: false
---

# `cannot update tuples during a parallel operation`

## What it means

Internal / usage error. A data-modifying action (an update or delete of a heap tuple) was attempted from within a parallel operation. Parallel workers run in a read-only mode with respect to the main table storage, so writes from that context are rejected.

## When it happens

A parallel plan node, or user code running in a parallel worker (such as a parallel-unsafe function mistakenly marked parallel-safe), attempted to modify rows.

## How to fix

Ensure functions that modify data are marked `PARALLEL UNSAFE` so the planner does not run them in parallel workers. If the write comes from your own function used in a parallel query, correct its parallel-safety marking. As a stopgap, disable parallelism for the statement.

## Example

*Illustrative* — a write attempted in a parallel worker.

```text
ERROR:  cannot update tuples during a parallel operation
```

## Related

- [cannot modify reindex state during a parallel operation](./cannot-modify-reindex-state-during-a-parallel-operation.md)
- [cannot create duplicate shared record typmod](./cannot-create-duplicate-shared-record-typmod.md)
