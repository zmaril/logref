---
message: "CTE subplans should not be executed via ExecSetParamPlan"
slug: cte-subplans-should-not-be-executed-via-execsetparamplan
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeSubplan.c:1135"
reproduced: false
---

# `CTE subplans should not be executed via ExecSetParamPlan`

## What it means

The executor reached a code path that tried to run a CTE subplan through the machinery meant for correlated sub-selects. CTEs are executed differently from parameterized subplans, so this combination is an internal invariant that should not occur.

## When it happens

It fires during query execution if a `WITH` common-table-expression subplan is dispatched through the wrong executor entry point. On correct plans this cannot happen.

## How to fix

This is an internal guard, not a user error. If you hit it, capture the exact query and its `EXPLAIN` output and report it, since it points at a planner or executor bug. No configuration change is expected to be needed.

## Example

*Illustrative* — an internal executor invariant failed.

```text
ERROR:  CTE subplans should not be executed via ExecSetParamPlan
```

## Related

- [CTE subplans should not be executed via ExecSubPlan](./cte-subplans-should-not-be-executed-via-execsubplan.md)
- [could not retrieve tle for sort-from-groupcols](./could-not-retrieve-tle-for-sort-from-groupcols.md)
