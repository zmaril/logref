---
message: "timestamp out of range: \"%g\""
slug: timestamp-out-of-range-ed2693
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_VALUE_OUT_OF_RANGE
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/timestamp.c:747"
  - "postgres/src/backend/utils/adt/timestamp.c:759"
reproduced: false
---

# `timestamp out of range: "%g"`

## What it means

A conversion of a floating-point value to a timestamp produced a result outside the representable range. The placeholder is the input value. The number, interpreted as a timestamp, is too large or too small for the type.

## When it happens

It arises from converting an epoch/float value to a timestamp (for example `to_timestamp(double)`) where the value maps to a date beyond the supported range, or is infinite/NaN in a context that rejects it.

## How to fix

Ensure the numeric input maps to a date within the supported range, and reject infinite/NaN inputs before conversion. Validate epoch values that come from external sources before turning them into timestamps.

## Example

*Illustrative* — converting an out-of-range float to timestamp.

```text
ERROR:  timestamp out of range: "1e30"
```

## Related

- [timestamp out of range: %d-%02d-%02d %d:%02d:%02g](./timestamp-out-of-range-2ef2cd.md)
- [result is out of range](./result-is-out-of-range.md)
