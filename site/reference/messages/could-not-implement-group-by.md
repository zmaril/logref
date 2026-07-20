---
message: "could not implement GROUP BY"
slug: could-not-implement-group-by
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/optimizer/plan/planner.c:2526"
  - "postgres/src/backend/optimizer/plan/planner.c:4405"
reproduced: false
---

# `could not implement GROUP BY`

## What it means

The planner could not build a plan for a `GROUP BY`, `DISTINCT`, or window `PARTITION BY` because a grouping column's type supports neither sorting nor hashing. Grouping needs at least one of an ordering operator or a hash function, and this type has neither.

## When it happens

Grouping or de-duplicating on a column whose type lacks both a b-tree operator class and a hash operator class — for example grouping on an `xml` value.

## How to fix

Cast the grouping expression to a groupable type (often `::text`), or exclude the column from the grouping. For a custom type, add a b-tree or hash operator class so it can be grouped.

## Example

*Illustrative* — GROUP BY on an xml column.

```text
ERROR:  could not implement GROUP BY
DETAIL:  Some of the datatypes only support hashing, while others only support sorting.
```

## Related

- [could not identify an ordering operator for type](./could-not-identify-an-ordering-operator-for-type.md)
- [could not identify an extended hash function for type](./could-not-identify-an-extended-hash-function-for-type.md)
