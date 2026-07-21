---
message: "dimension values cannot be null"
slug: dimension-values-cannot-be-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:6133"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:6159"
reproduced: false
---

# `dimension values cannot be null`

## What it means

An array-shape argument contained a null element. The individual dimension (or lower-bound) values that describe an array's shape must all be non-null integers.

## When it happens

Passing a dimensions or lower-bounds array that includes a NULL element to a function such as `array_fill`.

## How to fix

Ensure every element of the dimensions and lower-bounds arrays is a non-null integer. Remove or replace NULL elements before the call.

## Example

*Illustrative* — a null element in the dimensions array.

```text
ERROR:  dimension values cannot be null
```

## Related

- [dimension array or low bound array cannot be null](./dimension-array-or-low-bound-array-cannot-be-null.md)
- [count must be greater than zero](./count-must-be-greater-than-zero.md)
