---
message: "input is out of range"
slug: input-is-out-of-range
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE
    code: "22003"
call_sites:
  - "postgres/src/backend/utils/adt/float.c:1811"
  - "postgres/src/backend/utils/adt/float.c:1842"
  - "postgres/src/backend/utils/adt/float.c:1937"
  - "postgres/src/backend/utils/adt/float.c:1964"
  - "postgres/src/backend/utils/adt/float.c:1992"
  - "postgres/src/backend/utils/adt/float.c:2019"
  - "postgres/src/backend/utils/adt/float.c:2166"
  - "postgres/src/backend/utils/adt/float.c:2203"
  - "postgres/src/backend/utils/adt/float.c:2373"
  - "postgres/src/backend/utils/adt/float.c:2429"
  - "postgres/src/backend/utils/adt/float.c:2494"
  - "postgres/src/backend/utils/adt/float.c:2551"
  - "postgres/src/backend/utils/adt/float.c:2742"
  - "postgres/src/backend/utils/adt/float.c:2766"
reproduced: false
---

# `input is out of range`

## What it means

A floating-point math function was given an argument outside its valid domain, or produced a result too large to represent. The check guards functions like `exp`, `pow`, `sqrt`, and the hyperbolic/inverse functions where certain inputs have no real, finite result.

## When it happens

`exp()` of a large exponent (overflow), `sqrt()` or `ln()` of a negative number, `asin`/`acos` outside [-1, 1], or `power()` producing an overflowing magnitude. It fires from the `float4`/`float8` math functions rather than from casts.

## How to fix

Constrain the argument to the function's valid domain, or guard the call (for example filter out negatives before `sqrt`, or clamp inputs to `asin`/`acos`). If overflow is the issue, the value genuinely exceeds double precision — rethink the computation or work in `numeric` where appropriate. Validate inputs upstream so out-of-domain values do not reach the function.

## Example

*Illustrative* — an exponent that overflows double precision.

```sql
SELECT exp(1000);
```

Produces:

```text
ERROR:  input is out of range
```

## Related

- [smallint out of range](./smallint-out-of-range.md)
- [interval out of range](./interval-out-of-range.md)
