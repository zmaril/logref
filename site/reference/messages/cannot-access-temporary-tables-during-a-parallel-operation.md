---
message: "cannot access temporary tables during a parallel operation"
slug: cannot-access-temporary-tables-during-a-parallel-operation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TRANSACTION_STATE
    code: "25000"
call_sites:
  - "postgres/src/backend/storage/buffer/localbuf.c:767"
reproduced: false
---

# `cannot access temporary tables during a parallel operation`

## What it means

A parallel worker tried to read or write a temporary table. Temporary tables are private to the session that created them and are not shared with parallel workers, so they cannot be accessed inside parallel execution.

## When it happens

It occurs when a query that touches a temporary table is executed in parallel, which normally the planner avoids, or when an extension forces parallelism over temp-table access.

## How to fix

Prevent parallel execution for statements that use temporary tables — for example by setting `max_parallel_workers_per_gather = 0` for that query. In practice the planner does not parallelize plans that reference temporary tables, so this points at forced parallelism worth removing.

## Example

*Illustrative* — a temp table under parallel execution.

```text
ERROR:  cannot access temporary tables during a parallel operation
```

## Related

- [cannot abort during a parallel operation](./cannot-abort-during-a-parallel-operation.md)
- [cannot access temporary or unlogged relations during recovery](./cannot-access-temporary-or-unlogged-relations-during-recovery.md)
