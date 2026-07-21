---
message: "timestamp out of range: %d-%02d-%02d %d:%02d:%02g"
slug: timestamp-out-of-range-2ef2cd
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_VALUE_OUT_OF_RANGE
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/timestamp.c:620"
  - "postgres/src/backend/utils/adt/timestamp.c:628"
reproduced: false
---

# `timestamp out of range: %d-%02d-%02d %d:%02d:%02g`

## What it means

A timestamp built from individual date/time fields fell outside the representable range. The placeholders show the year-month-day and time components. The combination exceeds the limits of the timestamp type.

## When it happens

It arises from constructing a `timestamp` via `make_timestamp`/`make_timestamptz` or arithmetic where the resulting date is beyond the supported range (roughly 4713 BC to 294276 AD).

## How to fix

Keep constructed timestamps within the supported range, and validate field values. For dates outside the range, a different representation is needed; the timestamp type cannot store them.

## Example

*Illustrative* — constructing a timestamp beyond the range.

```text
ERROR:  timestamp out of range: 300000-01-01 00:00:00
```

## Related

- [timestamp out of range: "%g"](./timestamp-out-of-range-ed2693.md)
- [time field value out of range: %d:%02d:%02g](./time-field-value-out-of-range.md)
