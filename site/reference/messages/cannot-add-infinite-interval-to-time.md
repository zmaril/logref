---
message: "cannot add infinite interval to time"
slug: cannot-add-infinite-interval-to-time
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_VALUE_OUT_OF_RANGE
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/date.c:2175"
  - "postgres/src/backend/utils/adt/date.c:2725"
reproduced: false
---

# `cannot add infinite interval to time`

## What it means

An arithmetic expression tried to add an infinite `interval` to a `time` value. A `time` of day has no representation for infinity, so the operation has no defined result and is rejected.

## When it happens

Adding an interval that is `'infinity'` or `'-infinity'` to a `time` column or literal — often because an interval computed elsewhere overflowed to infinity or was set to infinity deliberately.

## How to fix

Ensure the interval operand is finite before adding it to a `time`. Filter or guard against infinite intervals (`WHERE iv <> 'infinity' AND iv <> '-infinity'`), or use `timestamptz` arithmetic where infinity is meaningful if that is what you intend.

## Example

*Illustrative* — adding an infinite interval to a time.

```sql
SELECT time '12:00' + interval 'infinity';
-- ERROR:  cannot add infinite interval to time
```

## Related

- [cannot subtract infinite interval from time](./cannot-subtract-infinite-interval-from-time.md)
- [cannot convert infinity to jsonb](./cannot-convert-infinity-to-jsonb.md)
