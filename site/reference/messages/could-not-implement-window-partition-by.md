---
message: "could not implement window PARTITION BY"
slug: could-not-implement-window-partition-by
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/optimizer/plan/planner.c:6551"
reproduced: false
---

# `could not implement window PARTITION BY`

## What it means

The planner could not build a plan for a window's `PARTITION BY` because a partitioning column's type supports neither sorting nor hashing. Grouping rows into window partitions needs a way to compare each column.

## When it happens

It fires while planning a window function whose `PARTITION BY` clause references a type with no b-tree or hash operator class — for example partitioning a window over an `xml` column.

## How to fix

Partition the window on a groupable type: cast the offending expression (often `::text`) or use a different column. For a custom type, add a b-tree or hash operator class so it can be used to form window partitions.

## Example

*Illustrative* — a window PARTITION BY over an ungroupable type.

```text
ERROR:  could not implement window PARTITION BY
DETAIL:  Window partitioning columns must be of sortable datatypes.
```

## Related

- [could not implement window order by](./could-not-implement-window-order-by.md)
- [could not implement distinct](./could-not-implement-distinct.md)
