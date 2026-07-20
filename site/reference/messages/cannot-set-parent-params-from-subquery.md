---
message: "cannot set parent params from subquery"
slug: cannot-set-parent-params-from-subquery
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/executor/nodeSubplan.c:77"
reproduced: false
---

# `cannot set parent params from subquery`

## What it means

An internal guard in the sub-plan executor fired: a subquery tried to set parameters that belong to a parent query level. Parameter flow goes from parent to child, so a child subquery cannot assign the parent's parameters.

## When it happens

It is reached when sub-plan execution reaches a state where a subquery would write parent-level parameters. It reflects a coding issue in planning or execution rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the query and any extension that hooks the planner or executor and report it, since parameter direction should always be parent to child.

## Example

*Illustrative* — a subquery setting parent parameters.

```text
ERROR:  cannot set parent params from subquery
```

## Related

- [cannot set collation for untransformed sublink](./cannot-set-collation-for-untransformed-sublink.md)
- [cannot push down CurrentOfExpr](./cannot-push-down-currentofexpr.md)
