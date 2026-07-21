---
message: "could not identify an inequality operator for type %s"
slug: could-not-identify-an-inequality-operator-for-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_FUNCTION
    code: "42883"
call_sites:
  - "postgres/src/backend/parser/parse_cte.c:307"
reproduced: false
---

# `could not identify an inequality operator for type %s`

## What it means

A recursive query's cycle or duplicate handling needs to compare values of a column's type for ordering, and that type has no inequality operator. Without a way to order the values, the check cannot be built.

## When it happens

It fires while parsing a recursive `WITH` query whose processing requires ordering a column whose type lacks a b-tree comparison operator — for example a type that supports only equality.

## How to fix

Use a column type that has a full set of comparison operators for the recursive query, or cast the offending expression to such a type. For a custom type, add a b-tree operator class so its values can be ordered.

## Example

*Illustrative* — a recursive query over a type with no ordering.

```text
ERROR:  could not identify an inequality operator for type point
```

## Related

- [could not identify an ordering operator for type](./could-not-identify-an-ordering-operator-for-type.md)
- [could not identify an intersect function for type](./could-not-identify-an-intersect-function-for-type.md)
