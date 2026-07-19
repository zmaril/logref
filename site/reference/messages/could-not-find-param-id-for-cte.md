---
message: "could not find param ID for CTE \"%s\""
slug: could-not-find-param-id-for-cte
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/plan/createplan.c:3938"
reproduced: false
---

# `could not find param ID for CTE "%s"`

## What it means

The planner could not find the parameter ID it assigned to a common table expression (CTE) while wiring up its plan. The `%s` names the CTE. This is an internal invariant of CTE planning.

## When it happens

It fires while the planner builds the plan for a query using a CTE, when the internal parameter linking the CTE to its scan is missing. Ordinary queries do not reach it.

## How to fix

This is an internal error. If a specific query with a CTE triggers it, note the exact statement and report a reproducible case.

## Example

*Illustrative* — a missing CTE parameter during planning.

```text
ERROR:  could not find param ID for CTE "my_cte"
```

## Related

- [could not find path for CTE](./could-not-find-path-for-cte.md)
- [could not find plan for CteScan referencing plan ID](./could-not-find-plan-for-ctescan-referencing-plan-id.md)
