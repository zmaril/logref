---
message: "cannot take logarithm of zero"
slug: cannot-take-logarithm-of-zero
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ARGUMENT_FOR_LOG
    code: "2201E"
call_sites:
  - "postgres/src/backend/utils/adt/float.c:1741"
  - "postgres/src/backend/utils/adt/float.c:1774"
  - "postgres/src/backend/utils/adt/numeric.c:3879"
  - "postgres/src/backend/utils/adt/numeric.c:10671"
reproduced: false
---

# `cannot take logarithm of zero`

## What it means

A logarithm function was applied to zero. The logarithm of zero is negative infinity — mathematically undefined as a finite value — so `ln`, `log`, or `log10` reject a zero argument rather than returning infinity.

## When it happens

Calling `ln(0)`, `log(0)`, or `log(b, 0)`, often because the argument comes from an expression or column that can be zero.

## How to fix

Ensure the argument is strictly positive. Filter out zero values, add a small positive offset if that is meaningful for your model, or guard with a `CASE` that handles zero explicitly.

## Example

*Illustrative* — logarithm of zero.

```sql
SELECT ln(0.0);
```

## Related

- [cannot take logarithm of a negative number](./cannot-take-logarithm-of-a-negative-number.md)
- [step size cannot equal zero](./step-size-cannot-equal-zero.md)
