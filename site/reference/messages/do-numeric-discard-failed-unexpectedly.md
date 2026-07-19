---
message: "do_numeric_discard failed unexpectedly"
slug: do-numeric-discard-failed-unexpectedly
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/numeric.c:5880"
reproduced: false
---

# `do_numeric_discard failed unexpectedly`

## What it means

An internal guard in the moving-aggregate machinery for `numeric`. Removing a value from a running aggregate's state failed when it should always succeed. This is a "can't happen" consistency check.

## When it happens

It fires during moving-window aggregation over `numeric` values (for example `avg`/`sum` in a moving window) when the inverse-transition step cannot discard a value it previously added.

## How to fix

This is not a user query error. If a specific query reproduces it, capture the query and data and report it to the PostgreSQL developers. As a workaround, an equivalent query without a moving window frame avoids the inverse-transition path.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  do_numeric_discard failed unexpectedly
```

## Related

- [deserialfunc not provided for deserialization aggregation](./deserialfunc-not-provided-for-deserialization-aggregation.md)
- [double to int overflow for](./double-to-int-overflow-for.md)
