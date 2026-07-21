---
message: "could not implement DISTINCT"
slug: could-not-implement-distinct
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/optimizer/plan/planner.c:5086"
reproduced: false
---

# `could not implement DISTINCT`

## What it means

The planner could not build a plan for `DISTINCT` because a selected column's type supports neither sorting nor hashing. Removing duplicates needs at least one of an ordering operator or a hash function on each column.

## When it happens

It fires while planning a `SELECT DISTINCT` (or `DISTINCT ON`) whose columns include a type with no b-tree operator class and no hash operator class — for example `DISTINCT` over an `xml` column.

## How to fix

Cast the offending column to a groupable type (often `::text`), or drop it from the `DISTINCT` list. For a custom type, add a b-tree or hash operator class so its values can be de-duplicated.

## Example

*Illustrative* — DISTINCT over an ungroupable column type.

```text
ERROR:  could not implement DISTINCT
DETAIL:  Some of the datatypes only support hashing, while others only support sorting.
```

## Related

- [could not implement](./could-not-implement.md)
- [could not implement window partition by](./could-not-implement-window-partition-by.md)
