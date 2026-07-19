---
message: "could not convert epoch to timestamp: %m"
slug: could-not-convert-epoch-to-timestamp
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/timestamp.c:2188"
reproduced: false
---

# `could not convert epoch to timestamp: %m`

## What it means

An internal conversion from a Unix epoch value to a PostgreSQL timestamp failed. This is an internal helper; the failure means the arithmetic produced an out-of-range or invalid result.

## When it happens

It fires from internal timestamp handling when an epoch value cannot be represented as a valid timestamp. It is not normally reachable from ordinary SQL with in-range inputs.

## How to fix

This is an internal error. If it appears from a specific query or extension, note the input that triggered it and report a reproducible case. Check for extreme or corrupted epoch values in the data feeding the conversion.

## Example

*Illustrative* — an epoch value that cannot become a timestamp.

```text
ERROR:  could not convert epoch to timestamp: Numerical result out of range
```

## Related

- [could not convert type to](./could-not-convert-type-to.md)
- [could not determine data type of concat() input](./could-not-determine-data-type-of-concat-input.md)
