---
message: "could not find path for CTE \"%s\""
slug: could-not-find-path-for-cte
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/path/allpaths.c:3221"
reproduced: false
---

# `could not find path for CTE "%s"`

## What it means

The planner could not find a computed access path for a common table expression (CTE). The `%s` names the CTE. This is an internal invariant: every planned CTE should have a path.

## When it happens

It fires while the planner assembles the plan for a query using a CTE and the CTE's path is missing. Ordinary queries do not reach it.

## How to fix

This is an internal error. If a specific query with a CTE triggers it, note the exact statement and report a reproducible case.

## Example

*Illustrative* — a missing CTE path during planning.

```text
ERROR:  could not find path for CTE "my_cte"
```

## Related

- [could not find param ID for CTE](./could-not-find-param-id-for-cte.md)
- [could not find plan for CteScan referencing plan ID](./could-not-find-plan-for-ctescan-referencing-plan-id.md)
