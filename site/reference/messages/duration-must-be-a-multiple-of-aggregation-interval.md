---
message: "duration (%d) must be a multiple of aggregation interval (%d)"
slug: duration-must-be-a-multiple-of-aggregation-interval
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:7284"
reproduced: false
---

# `duration (%d) must be a multiple of aggregation interval (%d)`

## What it means

`pgbench` was run with `--time`/`-T` (test duration) and `--aggregate-interval` whose values do not divide evenly. The placeholders are the duration and the interval. The total run time must be a whole multiple of the aggregation interval.

## When it happens

It fires at `pgbench` startup when the duration is not an integer multiple of the aggregation interval.

## How to fix

Choose a duration that is a whole multiple of the aggregation interval, or adjust the interval to divide the duration. For example use `-T 60 --aggregate-interval 10`, not `-T 65 --aggregate-interval 10`.

## Example

*Illustrative* — mismatched pgbench timing options.

```text
pgbench: error: duration (65) must be a multiple of aggregation interval (10)
```

## Related

- [empty command list for script](./empty-command-list-for-script.md)
- [double to int overflow for](./double-to-int-overflow-for.md)
