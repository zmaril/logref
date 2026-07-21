---
message: "double to int overflow for %f"
slug: double-to-int-overflow-for
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:2053"
reproduced: false
---

# `double to int overflow for %f`

## What it means

`pgbench` tried to convert a floating-point value to an integer and the value was outside the range an integer can hold. The placeholder is the offending value. It comes from arithmetic in a `pgbench` script.

## When it happens

It fires while `pgbench` evaluates a script expression that casts a double to an integer whose magnitude exceeds the 64-bit integer range.

## How to fix

Keep the computed value within the 64-bit integer range in your `pgbench` script. Check the scale factor and any custom variables or expressions that multiply large numbers, and use `double` arithmetic where a large fractional result is intended.

## Example

*Illustrative* — an over-range conversion in pgbench.

```text
pgbench: error: double to int overflow for 1e30
```

## Related

- [empty range given to random](./empty-range-given-to-random.md)
- [do_numeric_discard failed unexpectedly](./do-numeric-discard-failed-unexpectedly.md)
