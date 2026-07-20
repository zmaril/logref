---
message: "count must be greater than zero"
slug: count-must-be-greater-than-zero
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_ARGUMENT_FOR_WIDTH_BUCKET_FUNCTION
    code: "2201G"
call_sites:
  - "postgres/src/backend/utils/adt/float.c:4306"
  - "postgres/src/backend/utils/adt/numeric.c:1969"
reproduced: false
---

# `count must be greater than zero`

## What it means

A `width_bucket` call was given a bucket count that is zero or negative. The function divides a range into that many equal buckets, so the count must be a positive integer.

## When it happens

Calling `width_bucket(operand, low, high, count)` with `count <= 0`, often because the count came from an expression or column that evaluated to zero.

## How to fix

Pass a positive bucket count. Validate or clamp the value that feeds the `count` argument so it is at least 1.

## Example

*Illustrative* — a zero bucket count.

```text
ERROR:  count must be greater than zero
```

## Related

- [dimension values cannot be null](./dimension-values-cannot-be-null.md)
- [date out of range](./date-out-of-range-f6417b.md)
