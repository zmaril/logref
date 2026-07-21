---
message: "array must be one-dimensional"
slug: array-must-be-one-dimensional
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/contrib/ltree/_ltree_gist.c:63"
  - "postgres/contrib/ltree/_ltree_gist.c:485"
  - "postgres/contrib/ltree/_ltree_op.c:44"
  - "postgres/contrib/ltree/_ltree_op.c:144"
  - "postgres/contrib/ltree/_ltree_op.c:302"
  - "postgres/contrib/ltree/lquery_op.c:296"
  - "postgres/contrib/ltree/ltree_gist.c:598"
  - "postgres/src/backend/replication/logical/logicalfuncs.c:154"
reproduced: true
---

# `array must be one-dimensional`

## What it means

An operation that only handles one-dimensional arrays was given a multidimensional one. The placeholder situation: functions like `unnest`-adjacent helpers, extension array operations (`ltree`, `intarray`), and some conversions require a flat, 1-D array and reject nested dimensions.

## When it happens

Passing a 2-D (or higher) array to a function that expects 1-D, or building a multidimensional array where a flat one was intended. It commonly appears with `intarray`/`ltree` operators and with functions that treat arrays as simple lists.

## How to fix

Flatten the array to one dimension, or ensure it was constructed as 1-D. Check `array_ndims(arr)`; if it is greater than 1, the value has nesting you did not intend — often from concatenating arrays with `ARRAY[...]` in a way that adds a dimension. Restructure so the input is a single-dimension array.

## Example

*Reproduced* — captured from `reproducers/scenarios/62_contrib_type_input_deep.sql`.

```sql
SELECT '{{a}}'::ltree[] <@ 'a'::ltree;
```

Produces:

```text
ERROR:  array must be one-dimensional
```

## Related

- [wrong number of array subscripts](./wrong-number-of-array-subscripts.md)
- [array must not contain nulls](./array-must-not-contain-nulls.md)
