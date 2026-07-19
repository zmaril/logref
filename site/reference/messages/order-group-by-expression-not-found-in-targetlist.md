---
message: "ORDER/GROUP BY expression not found in targetlist"
slug: order-group-by-expression-not-found-in-targetlist
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/util/tlist.c:366"
  - "postgres/src/backend/optimizer/util/tlist.c:821"
reproduced: false
---

# `ORDER/GROUP BY expression not found in targetlist`

## What it means

Internal planner error. An `ORDER BY` or `GROUP BY` sort/grouping key was expected to correspond to an entry in the query's target list, and no matching entry was found while building the plan.

## When it happens

It fires deep in the planner when the grouping/ordering machinery cannot line a sort key up with a target-list column. Ordinary queries do not raise it; it points to an inconsistency in how a query tree was constructed.

## How to fix

This is an internal consistency guard, not a user-facing syntax error. If a real query triggers it, capture the exact statement and report it as a reproducible planner bug. Rewriting the `GROUP BY`/`ORDER BY` to reference plain output columns may work around it.

## Example

*Illustrative* — the planner failing to match a grouping key.

```text
ERROR:  ORDER/GROUP BY expression not found in targetlist
```

## Related

- [outer pathkeys do not match mergeclauses](./outer-pathkeys-do-not-match-mergeclauses.md)
- [subquery is bogus](./subquery-is-bogus.md)
