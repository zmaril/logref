---
message: "bigint div out of range"
slug: bigint-div-out-of-range
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:2413"
reproduced: false
---

# `bigint div out of range`

## What it means

Dividing two `bigint` values produced a result outside the 64-bit signed range. This happens in the one division case that overflows: the minimum `bigint` divided by minus one.

## When it happens

It occurs when the most negative `bigint` is divided by `-1`, whose true result is one past the maximum `bigint`.

## How to fix

Cast to `numeric` for the division, for example `a::numeric / b`, so the result fits. Guard against dividing the minimum `bigint` by minus one where that combination can arise.

## Example

*Illustrative* — the overflowing division.

```sql
SELECT (-9223372036854775808)::bigint / -1;
```

## Related

- [bigint mul out of range](./bigint-mul-out-of-range.md)
- [bigint add out of range](./bigint-add-out-of-range.md)
