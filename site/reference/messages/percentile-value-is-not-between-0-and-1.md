---
message: "percentile value %g is not between 0 and 1"
slug: percentile-value-is-not-between-0-and-1
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE
    code: "22003"
call_sites:
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:445"
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:550"
  - "postgres/src/backend/utils/adt/orderedsetaggs.c:690"
reproduced: false
---

# `percentile value %g is not between 0 and 1`

## What it means

An ordered-set aggregate such as `percentile_cont` or `percentile_disc` was given a percentile fraction outside the range 0 to 1. The fraction names a position within the sorted input and must be a probability between zero and one inclusive.

## When it happens

Calling `percentile_cont(p)` or `percentile_disc(p)` (or their array forms) with `p` less than 0 or greater than 1 — often because the value was expressed as a percentage like `95` instead of the fraction `0.95`.

## How to fix

Pass a fraction in the range 0 to 1. Convert percentages by dividing by 100, so the 95th percentile is `0.95`. For the array forms, ensure every element of the fraction array is within range.

## Example

*Illustrative* — a percentile given as a percentage.

```sql
SELECT percentile_cont(95) WITHIN GROUP (ORDER BY x) FROM t;  -- use 0.95
```

## Related

- [percentile value is not between 0 and 1](./percentile-value-is-not-between-0-and-1.md)
- [query returned more than one row](./query-returned-more-than-one-row.md)
