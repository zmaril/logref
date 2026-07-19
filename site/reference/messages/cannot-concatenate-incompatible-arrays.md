---
message: "cannot concatenate incompatible arrays"
slug: cannot-concatenate-incompatible-arrays
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/adt/array_userfuncs.c:370"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:409"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:446"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:475"
  - "postgres/src/backend/utils/adt/array_userfuncs.c:503"
reproduced: false
---

# `cannot concatenate incompatible arrays`

## What it means

Two arrays being concatenated with `||` do not share a compatible element type or a compatible shape. Array concatenation requires the same element type and dimensionally consistent operands; mismatched ones are rejected.

## When it happens

Concatenating arrays of different element types that have no implicit coercion, or arrays whose dimensionalities cannot be combined (for example joining a 1-D and a 2-D array in a way that does not line up).

## How to fix

Make the operands compatible: cast one array's elements to the other's type (`arr::text[]`), or restructure so both have matching dimensions. To append a single element to an array, use `array_append` or `arr || element` with a matching element type.

## Example

*Illustrative* — concatenating arrays of incompatible types.

```sql
SELECT ARRAY[1,2] || ARRAY['a','b'];
```

## Related

- [cannot accumulate arrays of different dimensionality](./cannot-accumulate-arrays-of-different-dimensionality.md)
- [multidimensional arrays must have array expressions with matching dimensions](./multidimensional-arrays-must-have-array-expressions-with-matching-dimensions.md)
