---
message: "cannot translate to multiple leaf relids"
slug: cannot-translate-to-multiple-leaf-relids
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/appendinfo.c:391"
reproduced: false
---

# `cannot translate to multiple leaf relids`

## What it means

An internal guard fired in the partition-pruning or append-translation code: a parent relation reference resolved to more than one leaf partition where exactly one was expected. The translation machinery cannot map a single reference onto several leaves, so this state should not occur.

## When it happens

It is reached from partitionwise planning that rewrites parent references into leaf references. It reflects an internal planner inconsistency rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the query, the partitioned table shape, and the plan, then report it. As a stopgap you can disable partitionwise features with `SET enable_partitionwise_join = off` and `SET enable_partitionwise_aggregate = off`.

## Example

*Illustrative* — the internal guard firing.

```text
ERROR:  cannot translate to multiple leaf relids
```

## Related

- [cannot use constant expression as partition key](./cannot-use-constant-expression-as-partition-key.md)
- [cannot store a toast pointer inside a range](./cannot-store-a-toast-pointer-inside-a-range.md)
