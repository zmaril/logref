---
message: "correlated subplans should not be executed via ExecSetParamPlan"
slug: correlated-subplans-should-not-be-executed-via-execsetparamplan
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeSubplan.c:1137"
reproduced: false
---

# `correlated subplans should not be executed via ExecSetParamPlan`

## What it means

The executor reached a code path that ran a correlated subplan through `ExecSetParamPlan`, which is only for uncorrelated (initplan) subplans. This is an internal consistency check.

## When it happens

It fires during execution when the subplan machinery is invoked in a way inconsistent with the subplan's correlation, indicating a planner/executor mismatch.

## How to fix

This is an internal error, not a user setting. Capture the query and its `EXPLAIN` plan and report it. As a workaround, rewriting the correlated subquery (for example as a join or with different structure) may avoid the path.

## Example

*Illustrative* — a correlated subplan on the initplan path.

```text
ERROR:  correlated subplans should not be executed via ExecSetParamPlan
```

## Related

- [combining Aggref does not point to an Aggref](./combining-aggref-does-not-point-to-an-aggref.md)
- [conflicting uses of row-identity name](./conflicting-uses-of-row-identity-name.md)
