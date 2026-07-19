---
message: "factorial of a negative number is undefined"
slug: factorial-of-a-negative-number-is-undefined
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE
    code: "22003"
call_sites:
  - "postgres/src/backend/utils/adt/numeric.c:3619"
reproduced: false
---

# `factorial of a negative number is undefined`

## What it means

The factorial function was applied to a negative integer. Factorial is only defined for non-negative integers, so a negative input is rejected as out of range.

## When it happens

It fires from the `factorial()` function or the legacy `!` factorial operator when given a negative argument.

## How to fix

Only call factorial on zero or positive integers. Validate or clamp the input before applying it, or filter out negative values. If you need a generalized factorial for non-integers, that is the gamma function, which PostgreSQL does not provide as a built-in.

## Example

*Illustrative* — factorial needs a non-negative input.

```sql
SELECT factorial(-3);  -- undefined
```

## Related

- [exponential parameter must be greater than zero (not)](./exponential-parameter-must-be-greater-than-zero-not.md)
- [expression contains variables](./expression-contains-variables.md)
