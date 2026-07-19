---
message: "time out of range"
slug: time-out-of-range
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATETIME_VALUE_OUT_OF_RANGE
    code: "22008"
call_sites:
  - "postgres/src/backend/utils/adt/date.c:1639"
  - "postgres/src/backend/utils/adt/date.c:2469"
reproduced: false
---

# `time out of range`

## What it means

A computed or supplied `time` value fell outside the representable range for the type. The result cannot be stored as a valid time-of-day value.

## When it happens

It arises from time arithmetic or conversion that produces a value beyond the type's bounds — for example adding an interval that pushes a time past its valid domain in a context that does not wrap.

## How to fix

Keep time computations within the valid range, or use `interval`/`timestamp` types where the arithmetic requires a broader domain. Validate inputs and intermediate results before storing them as `time`.

## Example

*Illustrative* — a time value out of range.

```text
ERROR:  time out of range
```

## Related

- [time field value out of range: %d:%02d:%02g](./time-field-value-out-of-range.md)
- [timestamp out of range: %d-%02d-%02d %d:%02d:%02g](./timestamp-out-of-range-2ef2cd.md)
