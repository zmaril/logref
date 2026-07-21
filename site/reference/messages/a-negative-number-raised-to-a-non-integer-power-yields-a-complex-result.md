---
message: "a negative number raised to a non-integer power yields a complex result"
slug: a-negative-number-raised-to-a-non-integer-power-yields-a-complex-result
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ARGUMENT_FOR_POWER_FUNCTION
    code: "2201F"
call_sites:
  - "postgres/src/backend/utils/adt/float.c:1565"
  - "postgres/src/backend/utils/adt/numeric.c:3971"
  - "postgres/src/backend/utils/adt/numeric.c:10891"
reproduced: true
---

# `a negative number raised to a non-integer power yields a complex result`

## What it means

A `power()` / `^` operation raised a negative base to a fractional exponent. In real arithmetic that has no real result (it would be a complex number), so Postgres reports it as a domain error rather than returning `NaN`.

## When it happens

Evaluating `power(x, y)` or `x ^ y` where `x` is negative and `y` is not an integer — for example a square root of a negative via `(-2) ^ 0.5`, often from computed values whose sign was not anticipated.

## How to fix

Ensure the base is non-negative before a fractional power, or handle negatives explicitly: take the power of the absolute value and reapply the sign where that is meaningful, or filter out negative bases. If you genuinely need complex results, that is outside the scope of the built-in numeric types.

## Example

*Reproduced* — captured from `reproducers/scenarios/30_type_io_numeric_int.sql`.

```sql
SELECT (-2::float8) ^ 0.5::float8;
```

Produces:

```text
ERROR:  a negative number raised to a non-integer power yields a complex result
```

## Related

- [cannot take square root of a negative number](./cannot-take-square-root-of-a-negative-number.md)
- [could not format inet value](./could-not-format-inet-value.md)
