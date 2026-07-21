---
message: "lower bound cannot equal upper bound"
slug: lower-bound-cannot-equal-upper-bound
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ARGUMENT_FOR_WIDTH_BUCKET_FUNCTION
    code: "2201G"
call_sites:
  - "postgres/src/backend/utils/adt/float.c:4382"
  - "postgres/src/backend/utils/adt/numeric.c:1995"
reproduced: false
---

# `lower bound cannot equal upper bound`

## What it means

`width_bucket` was given equal low and high bounds, which would make the bucket width zero. The bounds must differ so the range can be divided into buckets.

## When it happens

It arises from `width_bucket(operand, low, high, count)` when `low` and `high` are the same value.

## How to fix

Pass distinct low and high bounds that span the range you want to bucket. If the bounds come from data, ensure the minimum and maximum are not equal, or handle the single-value case separately.

## Example

*Illustrative* — identical bounds.

```sql
SELECT width_bucket(5, 10, 10, 4);  -- bounds must differ
```

## Related

- [lower and upper bounds cannot be NaN](./lower-and-upper-bounds-cannot-be-nan.md)
- [number is out of range](./number-is-out-of-range.md)
