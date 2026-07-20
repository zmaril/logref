---
message: "cannot subtract infinite interval from time"
slug: cannot-subtract-infinite-interval-from-time
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_VALUE_OUT_OF_RANGE
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/date.c:2199"
  - "postgres/src/backend/utils/adt/date.c:2753"
reproduced: false
---

# `cannot subtract infinite interval from time`

## What it means

An arithmetic expression tried to subtract an infinite `interval` from a `time` value. A `time` of day has no representation for infinity, so the operation has no defined result and is rejected.

## When it happens

Subtracting an interval that is `'infinity'` or `'-infinity'` from a `time` column or literal — often because an interval computed elsewhere overflowed to infinity.

## How to fix

Ensure the interval operand is finite before subtracting it from a `time`. Filter out infinite intervals, or use `timestamptz` arithmetic if infinity is a meaningful bound for your calculation.

## Example

*Illustrative* — subtracting an infinite interval from a time.

```sql
SELECT time '12:00' - interval 'infinity';
-- ERROR:  cannot subtract infinite interval from time
```

## Related

- [cannot add infinite interval to time](./cannot-add-infinite-interval-to-time.md)
- [cannot convert infinity to jsonb](./cannot-convert-infinity-to-jsonb.md)
