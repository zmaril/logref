---
message: "time field value out of range: %d:%02d:%02g"
slug: time-field-value-out-of-range
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_FIELD_OVERFLOW
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/date.c:1691"
  - "postgres/src/backend/utils/adt/timestamp.c:609"
reproduced: true
---

# `time field value out of range: %d:%02d:%02g`

## What it means

A time value had a field (hours, minutes, or seconds) outside its valid range. The placeholders show the offending components. A time must have hours 0–23, minutes 0–59, and seconds in range.

## When it happens

It arises when constructing or parsing a `time`/`timestamp` from field values that are out of bounds — for example `make_time(25, 0, 0)` or an input string with an impossible time.

## How to fix

Provide field values within range: hours 0–23, minutes 0–59, seconds 0–59 (with fractional seconds allowed). Validate or normalize inputs before building time values.

## Example

*Reproduced* — captured from `reproducers/scenarios/16_datetime_extended.sql`.

```sql
SELECT make_timestamptz(2024, 1, 1, 25, 0, 0);
```

Produces:

```text
ERROR:  time field value out of range: 25:00:00
```

## Related

- [time out of range](./time-out-of-range.md)
- [timestamp out of range: "%g"](./timestamp-out-of-range-ed2693.md)
