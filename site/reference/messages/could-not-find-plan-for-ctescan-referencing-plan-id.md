---
message: "could not find plan for CteScan referencing plan ID %d"
slug: could-not-find-plan-for-ctescan-referencing-plan-id
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/plan/subselect.c:2818"
reproduced: false
---

# `could not find plan for CteScan referencing plan ID %d`

## What it means

The planner could not find the subplan a `CteScan` node refers to by its plan ID. The `%d` is the plan ID. This is an internal invariant of CTE plan wiring.

## When it happens

It fires while the planner links a CTE scan to the plan that materializes the CTE, when that plan is missing. Ordinary queries do not reach it.

## How to fix

This is an internal error. If a specific query with a CTE triggers it, note the exact statement and report a reproducible case.

## Example

*Illustrative* — a CteScan referencing a missing plan.

```text
ERROR:  could not find plan for CteScan referencing plan ID 3
```

## Related

- [could not find path for CTE](./could-not-find-path-for-cte.md)
- [could not find RecursiveUnion for WorkTableScan with wtParam](./could-not-find-recursiveunion-for-worktablescan-with-wtparam.md)
