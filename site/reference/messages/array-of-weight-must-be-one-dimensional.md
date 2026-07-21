---
message: "array of weight must be one-dimensional"
slug: array-of-weight-must-be-one-dimensional
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
call_sites:
  - "postgres/src/backend/utils/adt/tsrank.c:436"
reproduced: false
---

# `array of weight must be one-dimensional`

## What it means

A text-search ranking function was given a multidimensional weight array, but the weights must be a single one-dimensional array.

## When it happens

It occurs in `ts_rank`/`ts_rank_cd` when the weights argument is a multidimensional array rather than a flat list of weights.

## How to fix

Pass a one-dimensional weight array. Flatten the array so it is a simple list of the label weights the function expects.

## Example

*Illustrative* — a multidimensional weights array.

```sql
SELECT ts_rank('{{0.1,0.2},{0.4,1.0}}', v, q);  -- ERROR:  array of weight must be one-dimensional
```

## Related

- [array of weight is too short](./array-of-weight-is-too-short.md)
- [array of weight must not contain nulls](./array-of-weight-must-not-contain-nulls.md)
