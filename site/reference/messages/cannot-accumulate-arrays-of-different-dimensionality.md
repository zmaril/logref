---
message: "cannot accumulate arrays of different dimensionality"
slug: cannot-accumulate-arrays-of-different-dimensionality
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
call_sites:
  - "postgres/src/backend/utils/adt/array_userfuncs.c:1051"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:1059"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:5650"
  - "postgres/src/backend/utils/adt/arrayfuncs.c:5656"
reproduced: false
---

# `cannot accumulate arrays of different dimensionality`

## What it means

`array_agg` (or a similar array-accumulating aggregate) received arrays that do not all have the same number of dimensions. To build a higher-dimensional array from array inputs, every input array must share the same dimensionality.

## When it happens

Aggregating array values with `array_agg` where some rows contribute a 1-D array and others a 2-D array, or otherwise mixing dimensionalities across the aggregated set.

## How to fix

Ensure every array fed to the aggregate has the same number of dimensions (and, for a rectangular result, matching sizes). Filter or normalize the inputs first, or aggregate scalars instead of arrays if a flat result is intended.

## Example

*Illustrative* — mixing 1-D and 2-D arrays in array_agg.

```sql
SELECT array_agg(a) FROM (VALUES (ARRAY[1]), (ARRAY[[1,2]])) v(a);
```

## Related

- [cannot concatenate incompatible arrays](./cannot-concatenate-incompatible-arrays.md)
- [multidimensional arrays must have array expressions with matching dimensions](./multidimensional-arrays-must-have-array-expressions-with-matching-dimensions.md)
