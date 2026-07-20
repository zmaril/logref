---
message: "no plan was made for CTE \"%s\""
slug: no-plan-was-made-for-cte
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/path/allpaths.c:3108"
  - "postgres/src/backend/optimizer/plan/createplan.c:3786"
  - "postgres/src/backend/utils/adt/selfuncs.c:6184"
reproduced: false
---

# `no plan was made for CTE "%s"`

## What it means

Internal error. The planner finished planning a query but found a common table expression for which no sub-plan was produced. Every referenced CTE should have a plan by this stage, and this one did not.

## When it happens

It should not occur through normal SQL. Reaching it points to an internal inconsistency in the planner's handling of CTEs, not to your query.

## How to fix

Treat it as an internal bug. Capture the query, including the `WITH` clause, and report it. Rephrasing the CTE — for example inlining it or materializing it explicitly — may work around it, but the underlying cause is on the planner side.

## Example

*Illustrative* — emitted internally after planning.

```text
ERROR:  no plan was made for CTE "cte_name"
```

## Related

- [no tlist entry for key](./no-tlist-entry-for-key.md)
- [left and right pathkeys do not match in mergejoin](./left-and-right-pathkeys-do-not-match-in-mergejoin.md)
