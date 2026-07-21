---
message: "interval out of range"
slug: interval-out-of-range
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_VALUE_OUT_OF_RANGE
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/timestamp.c:1579"
  - "postgres/src/backend/utils/adt/timestamp.c:2859"
  - "postgres/src/backend/utils/adt/timestamp.c:2868"
  - "postgres/src/backend/utils/adt/timestamp.c:2883"
  - "postgres/src/backend/utils/adt/timestamp.c:2957"
  - "postgres/src/backend/utils/adt/timestamp.c:2974"
  - "postgres/src/backend/utils/adt/timestamp.c:3031"
  - "postgres/src/backend/utils/adt/timestamp.c:3074"
  - "postgres/src/backend/utils/adt/timestamp.c:3458"
  - "postgres/src/backend/utils/adt/timestamp.c:3516"
  - "postgres/src/backend/utils/adt/timestamp.c:3539"
  - "postgres/src/backend/utils/adt/timestamp.c:3548"
  - "postgres/src/backend/utils/adt/timestamp.c:3572"
  - "postgres/src/backend/utils/adt/timestamp.c:3595"
  - "postgres/src/backend/utils/adt/timestamp.c:3604"
  - "postgres/src/backend/utils/adt/timestamp.c:3739"
  - "postgres/src/backend/utils/adt/timestamp.c:3840"
  - "postgres/src/backend/utils/adt/timestamp.c:4247"
  - "postgres/src/backend/utils/adt/timestamp.c:4284"
  - "postgres/src/backend/utils/adt/timestamp.c:4333"
  - "postgres/src/backend/utils/adt/timestamp.c:4342"
  - "postgres/src/backend/utils/adt/timestamp.c:4434"
  - "postgres/src/backend/utils/adt/timestamp.c:4482"
  - "postgres/src/backend/utils/adt/timestamp.c:4491"
  - "postgres/src/backend/utils/adt/timestamp.c:4587"
  - "postgres/src/backend/utils/adt/timestamp.c:4641"
  - "postgres/src/backend/utils/adt/timestamp.c:4651"
  - "postgres/src/backend/utils/adt/timestamp.c:4878"
  - "postgres/src/backend/utils/adt/timestamp.c:4888"
  - "postgres/src/backend/utils/adt/timestamp.c:5246"
reproduced: true
---

# `interval out of range`

## What it means

An `interval` value overflowed what the type can represent. Postgres stores intervals as separate months, days, and a microsecond field; arithmetic or input that overflows any of those fields (or the combined magnitude) is rejected.

## When it happens

Multiplying or adding intervals to very large magnitudes, `justify_interval` on extreme values, converting a huge number of seconds/days into an interval, or parsing an interval literal beyond the limits.

## How to fix

Keep interval magnitudes within range and check operands before arithmetic that scales them up. If you are aggregating durations, consider accumulating in a numeric count of a base unit (seconds) and only converting to interval at the end. Validate interval inputs coming from other systems.

## Example

*Reproduced* — captured from `reproducers/scenarios/32_adt_arithmetic_overflow.sql`.

```sql
SELECT 'infinity'::timestamp - 'infinity'::timestamp;
```

Produces:

```text
ERROR:  interval out of range
```

## Related

- [timestamp out of range](./timestamp-out-of-range-2f12c7.md)
- [input is out of range](./input-is-out-of-range.md)
