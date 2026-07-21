---
message: "origin out of range"
slug: origin-out-of-range
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_VALUE_OUT_OF_RANGE
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/timestamp.c:4625"
  - "postgres/src/backend/utils/adt/timestamp.c:4862"
reproduced: false
---

# `origin out of range`

## What it means

A date/time binning operation was given an origin timestamp that falls outside the range the type can represent, so the computed alignment point cannot be formed.

## When it happens

It arises from `date_bin` (and related binning) when the supplied origin argument is at or beyond the limits of the timestamp type, or when arithmetic on it overflows.

## How to fix

Choose an origin well within the representable timestamp range. For `date_bin`, an ordinary origin such as a fixed recent date works; extreme or out-of-domain origins are what trigger this.

## Example

*Illustrative* — binning with an origin at the edge of the type's range.

```text
ERROR:  origin out of range
```

## Related

- [timestamps cannot be binned into infinite intervals](./timestamps-cannot-be-binned-into-infinite-intervals.md)
- [stride must be greater than zero](./stride-must-be-greater-than-zero.md)
