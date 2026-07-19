---
message: "could not generate random seed"
slug: could-not-generate-random-seed
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:6703"
reproduced: false
---

# `could not generate random seed`

## What it means

`pgbench` tried to obtain a strong random seed for its own generators and the system random source failed. The seed makes each benchmark run's randomized workload reproducible or unique as requested.

## When it happens

It happens when starting `pgbench` with a seed derived from the operating-system random source, when that source is unavailable or returns an error.

## How to fix

Ensure the machine running `pgbench` has a working random source. As a workaround you can supply a fixed seed explicitly (for example via `--random-seed` or the `PGBENCH_RANDOM_SEED` environment variable) so it does not need to draw one from the system.

## Example

*Illustrative* — pgbench cannot obtain a random seed.

```text
pgbench: error: could not generate random seed
```

## Related

- [could not generate a random number](./could-not-generate-a-random-number.md)
- [could not initialize barrier](./could-not-initialize-barrier.md)
