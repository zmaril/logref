---
message: "could not implement %s"
slug: could-not-implement
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/optimizer/prep/prepunion.c:1114"
reproduced: false
---

# `could not implement %s`

## What it means

The planner could not build a plan for a set operation (`UNION`, `INTERSECT`, or `EXCEPT`) because a result column's type supports neither sorting nor hashing. Combining rows needs at least one of an ordering operator or a hash function.

## When it happens

It fires while planning a set operation whose columns include a type with no b-tree operator class and no hash operator class — for example combining queries that return an `xml` column.

## How to fix

Cast the offending column to a groupable type (often `::text`) on all branches of the set operation, or exclude it. For a custom type, add a b-tree or hash operator class so it can participate in set operations.

## Example

*Illustrative* — a set operation over an ungroupable column type.

```text
ERROR:  could not implement UNION
DETAIL:  Some of the datatypes only support hashing, while others only support sorting.
```

## Related

- [could not implement distinct](./could-not-implement-distinct.md)
- [could not implement recursive union](./could-not-implement-recursive-union.md)
