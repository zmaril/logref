---
message: "array of weight must not contain nulls"
slug: array-of-weight-must-not-contain-nulls
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/src/backend/utils/adt/tsrank.c:446"
reproduced: false
---

# `array of weight must not contain nulls`

## What it means

A text-search ranking function was given a weight array containing a NULL, but every weight must be a concrete number.

## When it happens

It occurs in `ts_rank`/`ts_rank_cd` when the weights argument includes a NULL element.

## How to fix

Ensure every element of the weights array is non-null. Replace or remove NULLs so all label weights are concrete numeric values.

## Example

*Illustrative* — a NULL inside the weights array.

```sql
SELECT ts_rank('{0.1,NULL,0.4,1.0}', v, q);  -- ERROR:  array of weight must not contain nulls
```

## Related

- [array of weight must be one-dimensional](./array-of-weight-must-be-one-dimensional.md)
- [array of weight is too short](./array-of-weight-is-too-short.md)
