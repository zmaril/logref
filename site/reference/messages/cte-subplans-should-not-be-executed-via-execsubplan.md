---
message: "CTE subplans should not be executed via ExecSubPlan"
slug: cte-subplans-should-not-be-executed-via-execsubplan
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeSubplan.c:75"
reproduced: false
---

# `CTE subplans should not be executed via ExecSubPlan`

## What it means

The executor reached a path that tried to run a CTE subplan through the general subplan-execution routine. As with the related guard, CTEs use their own execution mechanism, so this is an internal invariant.

## When it happens

It fires during execution if a `WITH` subplan is routed through the ordinary subplan executor. It should not be reachable on a correctly built plan.

## How to fix

This is an internal guard. Capture the query and `EXPLAIN` output and report it, since it indicates a bug in plan construction or execution rather than anything you can fix by changing the query.

## Example

*Illustrative* — an internal executor invariant failed.

```text
ERROR:  CTE subplans should not be executed via ExecSubPlan
```

## Related

- [CTE subplans should not be executed via ExecSetParamPlan](./cte-subplans-should-not-be-executed-via-execsetparamplan.md)
- [could not retrieve tle for sort-from-groupcols](./could-not-retrieve-tle-for-sort-from-groupcols.md)
