---
message: "cannot take square root of a negative number"
slug: cannot-take-square-root-of-a-negative-number
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ARGUMENT_FOR_POWER_FUNCTION
    code: "2201F"
call_sites:
  - "postgres/src/backend/utils/adt/float.c:1493"
  - "postgres/src/backend/utils/adt/numeric.c:3679"
  - "postgres/src/backend/utils/adt/numeric.c:10000"
reproduced: false
---

# `cannot take square root of a negative number`

## What it means

The `sqrt()` function (or `|/` operator) was applied to a negative number. The square root of a negative has no real value, so Postgres reports a domain error rather than returning `NaN`.

## When it happens

Calling `sqrt(x)` or `|/ x` where `x` is negative — often from a computed expression whose value can go below zero, such as a variance or difference that was assumed non-negative.

## How to fix

Ensure the argument is non-negative before taking the root: guard with a `CASE`/`WHERE`, clamp small negative round-off to zero, or fix the computation that produced a negative value. Complex results are outside the built-in numeric types.

## Example

*Illustrative* — square root of a negative number.

```sql
SELECT sqrt(-1);  -- cannot take square root of a negative number
```

## Related

- [a negative number raised to a non-integer power yields a complex result](./a-negative-number-raised-to-a-non-integer-power-yields-a-complex-result.md)
- [date out of range](./date-out-of-range-c5a525.md)
