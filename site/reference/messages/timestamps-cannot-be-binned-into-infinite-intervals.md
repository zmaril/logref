---
message: "timestamps cannot be binned into infinite intervals"
slug: timestamps-cannot-be-binned-into-infinite-intervals
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_VALUE_OUT_OF_RANGE
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/timestamp.c:4630"
  - "postgres/src/backend/utils/adt/timestamp.c:4867"
reproduced: false
---

# `timestamps cannot be binned into infinite intervals`

## What it means

A `date_bin` call used an infinite interval as the bin width. Binning divides time into finite buckets, so an infinite stride has no meaning.

## When it happens

It arises from `date_bin('infinity'::interval, ...)` or a computed interval that evaluates to infinity.

## How to fix

Use a finite interval as the bin width, such as `'1 hour'` or `'7 days'`. Guard against computed intervals becoming infinite before passing them to `date_bin`.

## Example

*Illustrative* — date_bin with an infinite interval.

```text
ERROR:  timestamps cannot be binned into infinite intervals
```

## Related

- [timestamps cannot be binned into intervals containing months or years](./timestamps-cannot-be-binned-into-intervals-containing-months-or-years.md)
- [stride must be greater than zero](./stride-must-be-greater-than-zero.md)
