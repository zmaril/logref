---
message: "lower and upper bounds cannot be NaN"
slug: lower-and-upper-bounds-cannot-be-nan
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ARGUMENT_FOR_WIDTH_BUCKET_FUNCTION
    code: "2201G"
call_sites:
  - "postgres/src/backend/utils/adt/float.c:4311"
  - "postgres/src/backend/utils/adt/numeric.c:1976"
reproduced: false
---

# `lower and upper bounds cannot be NaN`

## What it means

`width_bucket` was given `NaN` for one or both of its bound arguments. The histogram bounds must be ordinary finite numbers, so a `NaN` bound is rejected.

## When it happens

It arises from `width_bucket(operand, low, high, count)` when `low` or `high` evaluates to `NaN` — often from a prior division or a `NaN` propagated through the input.

## How to fix

Supply finite numeric bounds. Filter or replace `NaN` inputs before calling `width_bucket`, and verify the expressions that produce the bounds do not yield `NaN`.

## Example

*Illustrative* — a NaN bound.

```sql
SELECT width_bucket(5, 'NaN'::float8, 10, 4);  -- bounds cannot be NaN
```

## Related

- [lower bound cannot equal upper bound](./lower-bound-cannot-equal-upper-bound.md)
- [number is out of range](./number-is-out-of-range.md)
