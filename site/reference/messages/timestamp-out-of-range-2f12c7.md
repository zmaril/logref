---
message: "timestamp out of range"
slug: timestamp-out-of-range-2f12c7
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_VALUE_OUT_OF_RANGE
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/date.c:2089"
  - "postgres/src/backend/utils/adt/date.c:3227"
  - "postgres/src/backend/utils/adt/datetime.c:431"
  - "postgres/src/backend/utils/adt/datetime.c:1831"
  - "postgres/src/backend/utils/adt/ddlutils.c:245"
  - "postgres/src/backend/utils/adt/formatting.c:3974"
  - "postgres/src/backend/utils/adt/formatting.c:4010"
  - "postgres/src/backend/utils/adt/formatting.c:4095"
  - "postgres/src/backend/utils/adt/json.c:372"
  - "postgres/src/backend/utils/adt/json.c:411"
  - "postgres/src/backend/utils/adt/timestamp.c:241"
  - "postgres/src/backend/utils/adt/timestamp.c:273"
  - "postgres/src/backend/utils/adt/timestamp.c:701"
  - "postgres/src/backend/utils/adt/timestamp.c:710"
  - "postgres/src/backend/utils/adt/timestamp.c:789"
  - "postgres/src/backend/utils/adt/timestamp.c:822"
  - "postgres/src/backend/utils/adt/timestamp.c:3119"
  - "postgres/src/backend/utils/adt/timestamp.c:3128"
  - "postgres/src/backend/utils/adt/timestamp.c:3145"
  - "postgres/src/backend/utils/adt/timestamp.c:3150"
  - "postgres/src/backend/utils/adt/timestamp.c:3169"
  - "postgres/src/backend/utils/adt/timestamp.c:3182"
  - "postgres/src/backend/utils/adt/timestamp.c:3193"
  - "postgres/src/backend/utils/adt/timestamp.c:3199"
  - "postgres/src/backend/utils/adt/timestamp.c:3205"
  - "postgres/src/backend/utils/adt/timestamp.c:3210"
  - "postgres/src/backend/utils/adt/timestamp.c:3264"
  - "postgres/src/backend/utils/adt/timestamp.c:3273"
  - "postgres/src/backend/utils/adt/timestamp.c:3294"
  - "postgres/src/backend/utils/adt/timestamp.c:3299"
  - "postgres/src/backend/utils/adt/timestamp.c:3320"
  - "postgres/src/backend/utils/adt/timestamp.c:3333"
  - "postgres/src/backend/utils/adt/timestamp.c:3347"
  - "postgres/src/backend/utils/adt/timestamp.c:3355"
  - "postgres/src/backend/utils/adt/timestamp.c:3361"
  - "postgres/src/backend/utils/adt/timestamp.c:3366"
  - "postgres/src/backend/utils/adt/timestamp.c:4439"
  - "postgres/src/backend/utils/adt/timestamp.c:4592"
  - "postgres/src/backend/utils/adt/timestamp.c:4669"
  - "postgres/src/backend/utils/adt/timestamp.c:4736"
  - "postgres/src/backend/utils/adt/timestamp.c:4826"
  - "postgres/src/backend/utils/adt/timestamp.c:4906"
  - "postgres/src/backend/utils/adt/timestamp.c:4976"
  - "postgres/src/backend/utils/adt/timestamp.c:5079"
  - "postgres/src/backend/utils/adt/timestamp.c:5567"
  - "postgres/src/backend/utils/adt/timestamp.c:5842"
  - "postgres/src/backend/utils/adt/timestamp.c:6378"
  - "postgres/src/backend/utils/adt/timestamp.c:6388"
  - "postgres/src/backend/utils/adt/timestamp.c:6393"
  - "postgres/src/backend/utils/adt/timestamp.c:6399"
  - "postgres/src/backend/utils/adt/timestamp.c:6440"
  - "postgres/src/backend/utils/adt/timestamp.c:6657"
  - "postgres/src/backend/utils/adt/timestamp.c:6661"
  - "postgres/src/backend/utils/adt/timestamp.c:6667"
  - "postgres/src/backend/utils/adt/timestamp.c:6709"
  - "postgres/src/backend/utils/adt/xml.c:2616"
  - "postgres/src/backend/utils/adt/xml.c:2623"
  - "postgres/src/backend/utils/adt/xml.c:2643"
  - "postgres/src/backend/utils/adt/xml.c:2650"
reproduced: true
---

# `timestamp out of range`

## What it means

A `timestamp` or `timestamptz` value fell outside the range Postgres can represent. The supported range runs from 4713 BC to 294276 AD; arithmetic, casts, or input that lands beyond that is rejected rather than wrapped or truncated.

## When it happens

Adding a large `interval` to a timestamp, casting a huge epoch value with `to_timestamp`, importing out-of-range dates from another system, or `timestamp` arithmetic that overflows. It also appears when a computed value (for example `now() + '1000000 years'`) exceeds the maximum.

## How to fix

Keep values within the representable range, and validate inputs before inserting. If you are doing interval arithmetic, check the operands for unexpectedly large magnitudes. For data arriving from other systems (which may use different epoch limits), clamp or filter out-of-range values on the way in. There is no wider timestamp type, so the fix is to constrain the value, not the column.

## Example

*Reproduced* — captured from `reproducers/scenarios/32_adt_arithmetic_overflow.sql`.

```sql
SELECT '4713-01-01 BC'::timestamp - '1 year'::interval;
```

Produces:

```text
ERROR:  timestamp out of range
```

## Related

- [interval out of range](./interval-out-of-range.md)
- [date field value out of range](./date-field-value-out-of-range.md)
