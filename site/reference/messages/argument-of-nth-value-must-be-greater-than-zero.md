---
message: "argument of nth_value must be greater than zero"
slug: argument-of-nth-value-must-be-greater-than-zero
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ARGUMENT_FOR_NTH_VALUE
    code: "22016"
call_sites:
  - "postgres/src/backend/utils/adt/windowfuncs.c:715"
reproduced: false
---

# `argument of nth_value must be greater than zero`

## What it means

The `nth_value` window function was given a position argument of zero or negative, but it must be a positive integer indicating which value in the frame to return.

## When it happens

It occurs when `nth_value(expr, n)` is called with `n <= 0`.

## How to fix

Pass a positive integer for the position, counting from 1. If the position comes from data, guard it so it is at least 1, and handle the case where you have no valid nth value separately.

## Example

*Illustrative* — nth_value with a zero position.

```sql
SELECT nth_value(x, 0) OVER () FROM t;  -- ERROR
```

## Related

- [argument of ntile must be greater than zero](./argument-of-ntile-must-be-greater-than-zero.md)
- [a negative integer value cannot be specified for](./a-negative-integer-value-cannot-be-specified-for.md)
