---
message: "cannot handle unplanned sub-select"
slug: cannot-handle-unplanned-sub-select
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/optimizer/path/costsize.c:5173"
reproduced: false
---

# `cannot handle unplanned sub-select`

## What it means

An internal guard in the planner cost model fired: it met a sub-select that had not been planned yet where a planned sub-plan was expected. Costing a sub-select requires its sub-plan to already exist, and this one was still in raw form.

## When it happens

It is reached during cost estimation when a `SubLink` reaches the costing code without having been converted to a `SubPlan`. It reflects a coding issue rather than a user action.

## How to fix

There is no user-level fix. If it appears, capture the query and any extension that hooks the planner and report it, since sub-selects must be planned before they are costed.

## Example

*Illustrative* — an unplanned sub-select in the cost model.

```text
ERROR:  cannot handle unplanned sub-select
```

## Related

- [cannot handle qualified ON SELECT rule](./cannot-handle-qualified-on-select-rule.md)
- [cannot get collation for untransformed sublink](./cannot-get-collation-for-untransformed-sublink.md)
