---
message: "date out of range: %d-%02d-%02d"
slug: date-out-of-range-c5a525
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_VALUE_OUT_OF_RANGE
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/date.c:276"
  - "postgres/src/backend/utils/adt/date.c:285"
  - "postgres/src/backend/utils/adt/timestamp.c:600"
reproduced: false
---

# `date out of range: %d-%02d-%02d`

## What it means

A date computation produced a value outside the range the `date` type can represent. The placeholders are the year, month, and day of the offending result. Postgres dates span a wide but finite range; arithmetic or construction that lands beyond it overflows.

## When it happens

Adding a large interval to a date, constructing a date with an extreme year, or parsing/computing a value past the supported bounds (roughly 4713 BC to 5874897 AD).

## How to fix

Keep date values and arithmetic within the supported range. Validate inputs before constructing dates, and guard interval arithmetic that could push a date past the limit. If you need a wider span, store the value differently (for example as text or a numeric year) or clamp to the representable range.

## Example

*Illustrative* — date arithmetic overflowing the range.

```sql
SELECT date '5874897-12-31' + 1;  -- date out of range
```

## Related

- [cannot take square root of a negative number](./cannot-take-square-root-of-a-negative-number.md)
- [could not format inet value](./could-not-format-inet-value.md)
