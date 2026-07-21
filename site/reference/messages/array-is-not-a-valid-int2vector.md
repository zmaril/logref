---
message: "array is not a valid int2vector"
slug: array-is-not-a-valid-int2vector
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/adt/int.c:156"
reproduced: false
---

# `array is not a valid int2vector`

## What it means

A value was interpreted as an `int2vector` (the internal fixed small-integer vector used in catalogs) but did not have the shape a valid `int2vector` requires.

## When it happens

It occurs when converting or inputting an array into `int2vector` — often when constructing catalog-like values by hand — and the array is multidimensional, contains nulls, or is otherwise malformed for the type.

## How to fix

Provide a one-dimensional array of small integers with no nulls. `int2vector` is chiefly an internal catalog type; if you are not deliberately building catalog values, use a regular `smallint[]` instead.

## Example

*Illustrative* — a malformed int2vector value.

```text
ERROR:  array is not a valid int2vector
```

## Related

- [array is not a valid oidvector](./array-is-not-a-valid-oidvector.md)
- [arrays must have same bounds](./arrays-must-have-same-bounds.md)
