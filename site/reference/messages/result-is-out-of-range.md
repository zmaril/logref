---
message: "result is out of range"
slug: result-is-out-of-range
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE
    code: "22003"
call_sites:
  - "postgres/src/backend/utils/adt/network.c:1917"
  - "postgres/src/backend/utils/adt/network.c:1993"
reproduced: false
---

# `result is out of range`

## What it means

An arithmetic or conversion operation produced a value the target numeric type cannot represent. The computed result overflowed (or underflowed) the type's range.

## When it happens

It arises from math on integer, floating-point, or numeric types — multiplication/addition that exceeds the type's limits, or a cast to a narrower type whose value is out of range.

## How to fix

Use a wider type (for example `bigint` or `numeric`) for values that can grow large, add range checks, or scale/round the operation so the result fits. For casts, validate the source value fits the target type first.

## Example

*Illustrative* — integer arithmetic that overflows.

```text
ERROR:  integer out of range
-- or, for other types:
ERROR:  result is out of range
```

## Related

- [time field value out of range: %d:%02d:%02g](./time-field-value-out-of-range.md)
- [total size of jsonb array elements exceeds the maximum of %d bytes](./total-size-of-jsonb-array-elements-exceeds-the-maximum-of-bytes.md)
