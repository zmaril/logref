---
message: "data type %s is not an array type"
slug: data-type-is-not-an-array-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/utils/adt/arrayfuncs.c:5531"
reproduced: false
---

# `data type %s is not an array type`

## What it means

An operation that expects an array type was given a non-array type. The placeholder is the type. Array functions and some definitions require the type to be an array. The server reports it as a data-type mismatch.

## When it happens

It happens when a scalar or other non-array type is used where an array is required — for example passing a non-array to a function that operates on array types.

## How to fix

Supply an array type where one is required. If you have a scalar, wrap it in an array (for example `ARRAY[x]`), or use the array form of the type. Check the function or definition's expected argument types.

## Example

*Illustrative* — a scalar where an array type is required.

```sql
SELECT array_dims(42);
-- ERROR:  data type integer is not an array type
```

## Related

- [data type is a pseudo-type](./data-type-is-a-pseudo-type.md)
- [cube index is out of bounds](./cube-index-is-out-of-bounds.md)
