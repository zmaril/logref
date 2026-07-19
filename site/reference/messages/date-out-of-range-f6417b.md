---
message: "date out of range: \"%s\""
slug: date-out-of-range-f6417b
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_VALUE_OUT_OF_RANGE
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/formatting.c:4126"
  - "postgres/src/backend/utils/adt/formatting.c:4134"
reproduced: false
---

# `date out of range: "%s"`

## What it means

A text-to-date conversion produced a date outside the supported range. The `%s` is the input string. `to_date`/`to_timestamp` parsing yielded a value Postgres cannot represent as a date.

## When it happens

Parsing a string whose year or components fall outside the date type's range, often from a template mismatch or an out-of-range year in the input.

## How to fix

Check the input string against the format template and ensure the resulting date is within range. Correct the data or the `to_date`/`to_timestamp` pattern.

## Example

*Illustrative* — a parsed date outside the range.

```text
ERROR:  date out of range: "12345678-01-01"
```

## Related

- [date out of range for timestamp](./date-out-of-range-for-timestamp.md)
- [count must be greater than zero](./count-must-be-greater-than-zero.md)
