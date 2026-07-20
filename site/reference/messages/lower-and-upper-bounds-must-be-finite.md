---
message: "lower and upper bounds must be finite"
slug: lower-and-upper-bounds-must-be-finite
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ARGUMENT_FOR_WIDTH_BUCKET_FUNCTION
    code: "2201G"
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/float.c:4316"
  - "postgres/src/backend/utils/adt/numeric.c:1981"
  - "postgres/src/backend/utils/adt/pseudorandomfuncs.c:212"
  - "postgres/src/backend/utils/adt/pseudorandomfuncs.c:238"
  - "postgres/src/backend/utils/adt/pseudorandomfuncs.c:264"
reproduced: false
---

# `lower and upper bounds must be finite`

## What it means

A bucketing function (`width_bucket` over floating-point bounds) was given a lower or upper bound that is not finite — an infinity or NaN. The function partitions a finite range into equal buckets, which is undefined when a bound is not finite.

## When it happens

Calling `width_bucket(operand, low, high, count)` where `low` or `high` is `'infinity'`, `'-infinity'`, or `'NaN'`, often because those bounds come from a computed expression that overflowed.

## How to fix

Supply finite numeric bounds. Validate or clamp the bound expressions before the call, and filter out non-finite values. If your data legitimately spans an unbounded range, choose explicit finite limits for the bucketing.

## Example

*Illustrative* — a non-finite bucket bound.

```sql
SELECT width_bucket(5.0, '-infinity'::float8, 10.0, 4);
```

## Related

- [cannot take logarithm of a negative number](./cannot-take-logarithm-of-a-negative-number.md)
- [step size cannot equal zero](./step-size-cannot-equal-zero.md)
