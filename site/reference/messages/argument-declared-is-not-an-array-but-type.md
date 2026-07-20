---
message: "argument declared %s is not an array but type %s"
slug: argument-declared-is-not-an-array-but-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_coerce.c:2282"
  - "postgres/src/backend/parser/parse_coerce.c:2395"
  - "postgres/src/backend/utils/fmgr/funcapi.c:600"
reproduced: false
---

# `argument declared %s is not an array but type %s`

## What it means

A polymorphic function declared an argument or result as `anyarray`, but the value supplied at that position is not an array. The placeholders are the declared pseudotype and the actual type. `anyarray` requires an array so its element type can be determined.

## When it happens

Passing a scalar where an `anyarray` parameter is expected, or a function whose polymorphic resolution yields a non-array at an `anyarray` position.

## How to fix

Supply an array value (or cast to the intended array type) at the `anyarray` argument. If you meant to pass a single element, wrap it in an array (`ARRAY[x]`) or use the scalar-oriented `anyelement` form of the function instead.

## Example

*Illustrative* — a scalar passed where anyarray is required.

```text
ERROR:  argument declared anyarray is not an array but type integer
```

## Related

- [argument declared is not a range type but type](./argument-declared-is-not-a-range-type-but-type.md)
- [argument must be empty or one-dimensional array](./argument-must-be-empty-or-one-dimensional-array.md)
