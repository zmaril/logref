---
message: "dimension array or low bound array cannot be null"
slug: dimension-array-or-low-bound-array-cannot-be-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:6024"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:6064"
reproduced: false
---

# `dimension array or low bound array cannot be null`

## What it means

An array-construction function (for example `array_fill`) was given a null dimensions array or a null lower-bounds array. These arrays define the array's shape and cannot be null.

## When it happens

Calling `array_fill(value, dims)` or its lower-bounds variant with a NULL passed for the dimensions or lower-bounds argument.

## How to fix

Supply non-null integer arrays for the dimensions and lower bounds. Guard against NULLs in the expressions that produce those arguments.

## Example

*Illustrative* — a null dimensions array.

```text
ERROR:  dimension array or low bound array cannot be null
```

## Related

- [dimension values cannot be null](./dimension-values-cannot-be-null.md)
- [count must be greater than zero](./count-must-be-greater-than-zero.md)
