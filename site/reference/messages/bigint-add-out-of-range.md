---
message: "bigint add out of range"
slug: bigint-add-out-of-range
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:2358"
reproduced: false
---

# `bigint add out of range`

## What it means

Adding two `bigint` values produced a result that does not fit in the 64-bit signed `bigint` range. The addition overflowed.

## When it happens

It occurs when a `bigint` addition, in a query or an aggregate like `sum`, produces a value beyond roughly plus or minus nine quintillion.

## How to fix

Cast the operands to `numeric` before adding so the result can grow, for example `a::numeric + b::numeric`. Use `numeric` when totals can exceed the `bigint` range, and validate inputs if unexpected magnitudes signal a data problem.

## Example

*Illustrative* — a bigint sum overflowing.

```sql
SELECT 9223372036854775807::bigint + 1;
```

## Related

- [bigint sub out of range](./bigint-sub-out-of-range.md)
- [bigint mul out of range](./bigint-mul-out-of-range.md)
