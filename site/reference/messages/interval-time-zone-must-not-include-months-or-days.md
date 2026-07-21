---
message: "interval time zone \"%s\" must not include months or days"
slug: interval-time-zone-must-not-include-months-or-days
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/date.c:3266"
  - "postgres/src/backend/utils/adt/timestamp.c:6429"
  - "postgres/src/backend/utils/adt/timestamp.c:6698"
reproduced: false
---

# `interval time zone "%s" must not include months or days`

## What it means

A time-zone offset given as an `interval` contained a month or day component. A zone displacement must be a pure hours-and-minutes offset, because months and days are not fixed spans of time and cannot describe a constant offset from UTC.

## When it happens

Passing an interval like `interval '1 day 3 hours'` to a function that treats the interval as a time-zone offset, when you meant only the hours-and-minutes part.

## How to fix

Strip the month and day fields and pass only an hours-and-minutes interval, such as `interval '3 hours'`. If you need a named zone with its own daylight rules, pass the zone name as text instead of an interval.

## Example

*Illustrative* — a day component in a zone offset.

```sql
SELECT timezone(interval '1 day', now());  -- offset may not include days
```

## Related

- [interval time zone must be finite](./interval-time-zone-must-be-finite.md)
- [invalid value for option](./invalid-value-for-option.md)
