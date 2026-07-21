---
message: "stride must be greater than zero"
slug: stride-must-be-greater-than-zero
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_VALUE_OUT_OF_RANGE
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/timestamp.c:4646"
  - "postgres/src/backend/utils/adt/timestamp.c:4883"
reproduced: false
---

# `stride must be greater than zero`

## What it means

A binning stride (interval width) was given as zero or negative. The width of each bin must be a positive quantity.

## When it happens

It arises from `date_bin` (and related interval-binning) when the stride/interval argument is zero or negative.

## How to fix

Pass a positive interval as the stride, for example `'15 minutes'`. A zero or negative width does not define valid bins.

## Example

*Illustrative* — a non-positive date_bin stride.

```text
ERROR:  stride must be greater than zero
```

## Related

- [step size cannot be infinite](./step-size-cannot-be-infinite.md)
- [origin out of range](./origin-out-of-range.md)
