---
message: "bigint sub out of range"
slug: bigint-sub-out-of-range
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:2367"
reproduced: false
---

# `bigint sub out of range`

## What it means

Subtracting one `bigint` from another produced a result outside the 64-bit signed `bigint` range. The subtraction overflowed.

## When it happens

It occurs when a `bigint` subtraction crosses the type's bounds, for example subtracting a large negative value from a large positive one.

## How to fix

Cast the operands to `numeric` before subtracting, for example `a::numeric - b::numeric`. Choose `numeric` when the range of results can exceed `bigint`, and check inputs if the magnitudes look wrong.

## Example

*Illustrative* — a bigint difference overflowing.

```sql
SELECT (-9223372036854775808)::bigint - 1;
```

## Related

- [bigint add out of range](./bigint-add-out-of-range.md)
- [bigint mul out of range](./bigint-mul-out-of-range.md)
