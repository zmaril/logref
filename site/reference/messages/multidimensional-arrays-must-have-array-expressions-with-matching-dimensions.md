---
message: "multidimensional arrays must have array expressions with matching dimensions"
slug: multidimensional-arrays-must-have-array-expressions-with-matching-dimensions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
  - symbol: ERRCODE_INVALID_TEXT_REPRESENTATION
    code: "22P02"
call_sites:
  - "postgres/src/backend/executor/execExprInterp.c:3529"
  - "postgres/src/backend/executor/execExprInterp.c:3564"
  - "postgres/src/pl/plpython/plpy_typeio.c:1228"
  - "postgres/src/pl/plpython/plpy_typeio.c:1243"
  - "postgres/src/pl/plpython/plpy_typeio.c:1259"
reproduced: false
---

# `multidimensional arrays must have array expressions with matching dimensions`

## What it means

An array literal or `ARRAY[]` constructor mixed sub-arrays of different lengths, so the result is not a proper rectangular multidimensional array. Postgres arrays must be regular: every sub-array at a given level must have the same number of elements.

## When it happens

Building a nested array where the inner arrays differ in length — for example `ARRAY[ARRAY[1,2], ARRAY[3]]` — or parsing a text array literal whose rows are ragged.

## How to fix

Make all sub-arrays the same length so the array is rectangular, padding with a placeholder or `NULL` if needed. If your data is genuinely ragged, model it differently — an array of composite values, a `jsonb` structure, or a normalized child table — rather than a multidimensional array.

## Example

*Illustrative* — ragged nested arrays.

```sql
SELECT ARRAY[ARRAY[1,2], ARRAY[3]];
```

## Related

- [cannot concatenate incompatible arrays](./cannot-concatenate-incompatible-arrays.md)
- [array subscript out of range](./array-subscript-out-of-range.md)
