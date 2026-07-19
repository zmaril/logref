---
message: "cannot create duplicate shared record typmod"
slug: cannot-create-duplicate-shared-record-typmod
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/typcache.c:2280"
  - "postgres/src/backend/utils/cache/typcache.c:3020"
reproduced: false
---

# `cannot create duplicate shared record typmod`

## What it means

Internal error. The shared record-type registry (used by parallel workers to agree on anonymous record layouts) was asked to register a type modifier that already exists. It is a consistency check on that shared typmod table.

## When it happens

It should not occur through ordinary SQL. Reaching it points to an internal inconsistency in the parallel-query shared record machinery, not to anything in your query.

## How to fix

Treat it as an internal bug. Capture the query — especially if it uses parallel workers over anonymous record types — and report it. Disabling parallelism (`SET max_parallel_workers_per_gather = 0`) is a temporary workaround if the same query keeps hitting it.

## Example

*Illustrative* — emitted internally by the shared-typmod registry.

```text
ERROR:  cannot create duplicate shared record typmod
```

## Related

- [cannot update tuples during a parallel operation](./cannot-update-tuples-during-a-parallel-operation.md)
- [cannot modify reindex state during a parallel operation](./cannot-modify-reindex-state-during-a-parallel-operation.md)
