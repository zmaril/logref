---
message: "exponential parameter must be greater than zero (not %f)"
slug: exponential-parameter-must-be-greater-than-zero-not
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:2708"
reproduced: false
---

# `exponential parameter must be greater than zero (not %f)`

## What it means

A `pgbench` script used the exponential random-distribution function with a parameter that was not greater than zero. The placeholder is the value given. The exponential distribution requires a positive shape parameter.

## When it happens

It fires when a `pgbench` custom script calls `random_exponential(min, max, parameter)` with a parameter of zero or negative.

## How to fix

Pass a parameter greater than zero to `random_exponential`. Larger values concentrate results near the low end of the range; smaller positive values spread them out. Fix the value in the `pgbench` script and re-run.

## Example

*Illustrative* — the parameter must be positive.

```
\set x random_exponential(1, 100, 2.5)
```

## Related

- [Expecting an unsigned integer, "time" or "rand".](./expecting-an-unsigned-integer-time-or-rand.md)
- [error while setting random seed from --random-seed option](./error-while-setting-random-seed-from-random-seed-option.md)
