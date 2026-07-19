---
message: "array subscript out of range"
slug: array-subscript-out-of-range
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2253"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2377"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2656"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:2993"
reproduced: false
---

# `array subscript out of range`

## What it means

An array operation used a subscript outside the array's bounds in a context where that is not allowed. Reading a nonexistent element returns `NULL`, but some operations — assignment that would create a gap, or fixed-length array handling — reject an out-of-range subscript instead.

## When it happens

Assigning to an array element far beyond the current bounds so it would leave a gap, updating a fixed-size array element out of range, or an operation that requires the subscript to be within existing bounds.

## How to fix

Use a subscript within the array's bounds, or extend the array contiguously (append with `array_append` or `arr || elem`) rather than assigning past the end. Check the current bounds with `array_lower`/`array_upper` before an indexed assignment.

## Example

*Illustrative* — an out-of-range array subscript.

```sql
SELECT (ARRAY[1,2,3])[10:20];  -- context-dependent; assignment forms can error
```

## Related

- [multidimensional arrays must have array expressions with matching dimensions](./multidimensional-arrays-must-have-array-expressions-with-matching-dimensions.md)
- [cannot concatenate incompatible arrays](./cannot-concatenate-incompatible-arrays.md)
