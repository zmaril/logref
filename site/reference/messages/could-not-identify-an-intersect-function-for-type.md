---
message: "could not identify an intersect function for type %s"
slug: could-not-identify-an-intersect-function-for-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/parser/analyze.c:1572"
reproduced: false
---

# `could not identify an intersect function for type %s`

## What it means

An `INTERSECT` or `EXCEPT` between queries needs to match rows by value, and a column's type provides no way to do so. Set operations compare whole rows, which requires each column type to support equality (by hashing or sorting).

## When it happens

It fires while analyzing an `INTERSECT` or `EXCEPT` whose result columns include a type with neither a hash nor a b-tree operator class — for example a type that cannot be compared for equality.

## How to fix

Cast the offending column to a comparable type (often `::text`) on both sides of the set operation, or restructure the query to avoid comparing that column. For a custom type, add an equality/hash or b-tree operator class.

## Example

*Illustrative* — INTERSECT over an incomparable column type.

```text
ERROR:  could not identify an intersect function for type xml
```

## Related

- [could not identify an inequality operator for type](./could-not-identify-an-inequality-operator-for-type.md)
- [could not implement recursive union](./could-not-implement-recursive-union.md)
