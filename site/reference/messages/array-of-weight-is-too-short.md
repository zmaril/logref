---
message: "array of weight is too short"
slug: array-of-weight-is-too-short
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_ARRAY_SUBSCRIPT_ERROR
    code: "2202E"
call_sites:
  - "postgres/src/backend/utils/adt/tsrank.c:441"
reproduced: false
---

# `array of weight is too short`

## What it means

A text-search ranking function was given a weight array with fewer entries than the four label weights it expects, so it cannot map document labels to weights.

## When it happens

It occurs in `ts_rank`/`ts_rank_cd` (and related) when the optional weights array does not have the required number of elements for the A/B/C/D labels.

## How to fix

Supply a weight array with the full set of label weights the function expects (typically four values, one for each of the D, C, B, A labels). Provide all elements rather than a truncated array.

## Example

*Illustrative* — a too-short weights array for ranking.

```sql
SELECT ts_rank('{0.1,0.2}', v, q);  -- ERROR:  array of weight is too short
```

## Related

- [array of weight must be one-dimensional](./array-of-weight-must-be-one-dimensional.md)
- [array of weight must not contain nulls](./array-of-weight-must-not-contain-nulls.md)
