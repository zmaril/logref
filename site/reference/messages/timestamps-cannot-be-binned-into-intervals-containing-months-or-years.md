---
message: "timestamps cannot be binned into intervals containing months or years"
slug: timestamps-cannot-be-binned-into-intervals-containing-months-or-years
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/utils/adt/timestamp.c:4635"
  - "postgres/src/backend/utils/adt/timestamp.c:4872"
reproduced: false
---

# `timestamps cannot be binned into intervals containing months or years`

## What it means

A `date_bin` call used an interval that includes month or year components. Because months and years have variable length, they do not define uniform bins, so `date_bin` rejects them.

## When it happens

It arises from `date_bin('1 month', ...)` or any stride with month/year parts.

## How to fix

Use an interval built from fixed-length units (days, hours, minutes, seconds), for example `'30 days'`. To bucket by calendar month or year, use `date_trunc('month', ...)`/`date_trunc('year', ...)` instead, which understand calendar boundaries.

## Example

*Illustrative* — date_bin with a month interval.

```text
ERROR:  timestamps cannot be binned into intervals containing months or years
```

## Related

- [timestamps cannot be binned into infinite intervals](./timestamps-cannot-be-binned-into-infinite-intervals.md)
- [stride must be greater than zero](./stride-must-be-greater-than-zero.md)
