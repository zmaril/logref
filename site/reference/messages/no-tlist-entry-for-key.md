---
message: "no tlist entry for key %d"
slug: no-tlist-entry-for-key
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/explain.c:2739"
  - "postgres/src/backend/commands/explain.c:2818"
  - "postgres/src/backend/commands/explain.c:2991"
reproduced: false
---

# `no tlist entry for key %d`

## What it means

Internal error. While preparing to display or process a plan, the code looked for a target-list entry matching a sort or grouping key and did not find one. Every such key should have a corresponding target-list entry at this point.

## When it happens

It should not occur through normal SQL, including `EXPLAIN`. Reaching it points to an internal inconsistency in the planner's target-list bookkeeping, not to your query.

## How to fix

Treat it as an internal bug. Capture the query and, where possible, the plan, and report it. There is no query-side change expected to reliably trigger or avoid it.

## Example

*Illustrative* — emitted internally while handling a plan.

```text
ERROR:  no tlist entry for key 3
```

## Related

- [no plan was made for cte](./no-plan-was-made-for-cte.md)
- [left and right pathkeys do not match in mergejoin](./left-and-right-pathkeys-do-not-match-in-mergejoin.md)
