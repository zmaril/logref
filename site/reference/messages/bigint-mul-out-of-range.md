---
message: "bigint mul out of range"
slug: bigint-mul-out-of-range
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:2376"
reproduced: false
---

# `bigint mul out of range`

## What it means

Multiplying two `bigint` values produced a result that does not fit in the 64-bit signed `bigint` range. The multiplication overflowed.

## When it happens

It occurs when a `bigint` multiplication yields a value beyond the `bigint` limits, which happens quickly with large factors.

## How to fix

Cast the operands to `numeric` before multiplying, for example `a::numeric * b::numeric`, so the product can be represented. Use `numeric` wherever products can grow past the `bigint` range.

## Example

*Illustrative* — a bigint product overflowing.

```sql
SELECT 3037000500::bigint * 3037000500;
```

## Related

- [bigint add out of range](./bigint-add-out-of-range.md)
- [bigint div out of range](./bigint-div-out-of-range.md)
