---
message: "zero raised to a negative power is undefined"
slug: zero-raised-to-a-negative-power-is-undefined
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ARGUMENT_FOR_POWER_FUNCTION
    code: "2201F"
call_sites:
  - "postgres/src/backend/utils/adt/float.c:1561"
  - "postgres/src/backend/utils/adt/numeric.c:3967"
  - "postgres/src/backend/utils/adt/numeric.c:4079"
reproduced: false
---

# `zero raised to a negative power is undefined`

## What it means

An exponentiation computed zero to a negative power, which is mathematically undefined. Raising zero to a negative exponent is equivalent to dividing by zero, so Postgres raises an error rather than returning infinity.

## When it happens

Evaluating `power(0, n)` or `0 ^ n` (with `float8` or `numeric`) where the exponent is negative — usually because the base column or expression was zero for some rows while the exponent was negative.

## How to fix

Guard the base against zero when the exponent can be negative. Filter out or special-case zero bases, use `NULLIF(base, 0)` so the result becomes null, or restructure the computation to avoid a negative power of zero.

## Example

*Illustrative* — zero to a negative power.

```sql
SELECT 0 ^ -1;  -- undefined
```

## Related

- [cannot take logarithm of zero](./cannot-take-logarithm-of-zero.md)
- [a negative number raised to a non-integer power yields a complex result](./a-negative-number-raised-to-a-non-integer-power-yields-a-complex-result.md)
