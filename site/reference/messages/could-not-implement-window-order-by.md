---
message: "could not implement window ORDER BY"
slug: could-not-implement-window-order-by
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/optimizer/plan/planner.c:6556"
reproduced: false
---

# `could not implement window ORDER BY`

## What it means

The planner could not build a plan for a window's `ORDER BY` because the ordering column's type has no sort support. Ordering rows within a window frame needs a b-tree ordering operator for that type.

## When it happens

It fires while planning a window function whose `ORDER BY` clause sorts on a type with no b-tree operator class — for example ordering a window over an `xml` column.

## How to fix

Order the window on a sortable type: cast the offending expression (often `::text`) or use a different column. For a custom type, add a b-tree operator class so it can be ordered within a window.

## Example

*Illustrative* — a window ORDER BY over an unsortable type.

```text
ERROR:  could not implement window ORDER BY
DETAIL:  Window ordering columns must be of sortable datatypes.
```

## Related

- [could not implement window partition by](./could-not-implement-window-partition-by.md)
- [could not implement distinct](./could-not-implement-distinct.md)
