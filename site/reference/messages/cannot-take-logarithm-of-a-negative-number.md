---
message: "cannot take logarithm of a negative number"
slug: cannot-take-logarithm-of-a-negative-number
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ARGUMENT_FOR_LOG
    code: "2201E"
call_sites:
  - "postgres/src/backend/utils/adt/float.c:1745"
  - "postgres/src/backend/utils/adt/float.c:1778"
  - "postgres/src/backend/utils/adt/numeric.c:3817"
  - "postgres/src/backend/utils/adt/numeric.c:3874"
  - "postgres/src/backend/utils/adt/numeric.c:10675"
reproduced: false
---

# `cannot take logarithm of a negative number`

## What it means

A logarithm function was applied to a negative argument. The real logarithm is undefined for negative inputs, so `ln`, `log`, or `log10` reject them rather than returning a complex or NaN result.

## When it happens

Calling `ln(x)`, `log(x)`, or `log(b, x)` where the argument (or base) is negative — often because a computed column occasionally goes below zero.

## How to fix

Ensure the argument is positive. Filter or clamp negative values before the call, or guard with a `CASE` that handles non-positive inputs explicitly. If negative inputs are genuinely meaningful, logarithms are the wrong operation for them.

## Example

*Illustrative* — logarithm of a negative value.

```sql
SELECT ln(-1.0);
```

## Related

- [cannot take logarithm of zero](./cannot-take-logarithm-of-zero.md)
- [lower and upper bounds must be finite](./lower-and-upper-bounds-must-be-finite.md)
