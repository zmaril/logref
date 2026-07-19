---
message: "array must have two columns"
slug: array-must-have-two-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
call_sites:
  - "postgres/contrib/hstore/hstore_io.c:749"
  - "postgres/src/backend/utils/adt/json.c:1403"
  - "postgres/src/backend/utils/adt/jsonb.c:1314"
reproduced: false
---

# `array must have two columns`

## What it means

A function that builds a value from a two-column array (here `hstore`'s array constructor) was given an array whose second dimension is not exactly two. The two-column shape maps to key/value pairs; any other width cannot be interpreted.

## When it happens

Calling `hstore(text[])` (or a similar pair-oriented constructor) with a 2-D array whose inner arrays do not have exactly two elements — for example a mismatched key/value layout.

## How to fix

Shape the array as N rows of two columns: `ARRAY[['k1','v1'],['k2','v2']]`. If your keys and values are in separate arrays, use the two-argument `hstore(keys, values)` form instead, ensuring both arrays have the same length.

## Example

*Illustrative* — an array without exactly two columns.

```sql
SELECT hstore(ARRAY[['k','v','x']]);  -- array must have two columns
```

## Related

- [number of pairs exceeds the maximum allowed](./number-of-pairs-exceeds-the-maximum-allowed.md)
- [argument must be empty or one-dimensional array](./argument-must-be-empty-or-one-dimensional-array.md)
