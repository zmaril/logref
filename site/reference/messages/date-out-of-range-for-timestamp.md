---
message: "date out of range for timestamp"
slug: date-out-of-range-for-timestamp
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_VALUE_OUT_OF_RANGE
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/date.c:3030"
  - "postgres/src/backend/utils/adt/date.c:3040"
reproduced: false
---

# `date out of range for timestamp`

## What it means

A conversion between a `date` and a `timestamp` produced a value outside the timestamp range. A date far in the past or future cannot be represented as a timestamp.

## When it happens

Casting or combining an extreme `date` into a `timestamp`/`timestamptz`, or arithmetic that pushes a timestamp result beyond the supported bounds.

## How to fix

Keep timestamp values within the supported range, or work with the `date` type where the wider date range suffices. Validate extreme dates before converting.

## Example

*Illustrative* — a date beyond the timestamp range.

```text
ERROR:  date out of range for timestamp
```

## Related

- [date out of range](./date-out-of-range-f6417b.md)
- [count must be greater than zero](./count-must-be-greater-than-zero.md)
