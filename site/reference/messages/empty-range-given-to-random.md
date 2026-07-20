---
message: "empty range given to random"
slug: empty-range-given-to-random
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:2654"
reproduced: false
---

# `empty range given to random`

## What it means

A `pgbench` script called a `random()` function with a range whose lower bound was greater than its upper bound, leaving no values to choose from. The range must be non-empty.

## When it happens

It fires while `pgbench` evaluates a random-number function in a script when the computed bounds are reversed or equal in a way that leaves an empty interval.

## How to fix

Ensure the lower bound is less than or equal to the upper bound in the `pgbench` script's `random(lb, ub)` call. Check any variables or expressions that compute the bounds.

## Example

*Illustrative* — a reversed random range.

```text
pgbench: error: empty range given to random
```

## Related

- [double to int overflow for](./double-to-int-overflow-for.md)
- [empty command list for script](./empty-command-list-for-script.md)
