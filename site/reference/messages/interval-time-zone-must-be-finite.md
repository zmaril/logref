---
message: "interval time zone \"%s\" must be finite"
slug: interval-time-zone-must-be-finite
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/utils/adt/date.c:3259"
  - "postgres/src/backend/utils/adt/timestamp.c:6422"
  - "postgres/src/backend/utils/adt/timestamp.c:6691"
reproduced: false
---

# `interval time zone "%s" must be finite`

## What it means

A time-zone offset was supplied as an `interval` value, and that interval was infinity. A time-zone displacement has to be a finite amount of time, so an infinite interval cannot name a zone.

## When it happens

Passing `'infinity'::interval` (or an expression that evaluates to it) where a function such as `timezone(interval, timestamptz)` expects a fixed offset from UTC.

## How to fix

Use a finite interval for the offset, for example `interval '-5 hours'`, or name the zone as text (`'America/New_York'`). Check the expression that produced the interval if it unexpectedly evaluated to infinity.

## Example

*Illustrative* — an infinite offset.

```sql
SELECT timezone('infinity'::interval, now());  -- offset must be finite
```

## Related

- [interval time zone must not include months or days](./interval-time-zone-must-not-include-months-or-days.md)
- [invalid value for option](./invalid-value-for-option.md)
