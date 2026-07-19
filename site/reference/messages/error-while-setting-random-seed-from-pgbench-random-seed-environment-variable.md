---
message: "error while setting random seed from PGBENCH_RANDOM_SEED environment variable"
slug: error-while-setting-random-seed-from-pgbench-random-seed-environment-variable
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:6853"
reproduced: false
---

# `error while setting random seed from PGBENCH_RANDOM_SEED environment variable`

## What it means

`pgbench` could not use the value of the `PGBENCH_RANDOM_SEED` environment variable to seed its random-number generator. The value was not one `pgbench` accepts.

## When it happens

It fires at `pgbench` startup when `PGBENCH_RANDOM_SEED` is set to something other than an unsigned integer or one of the special keywords `time` or `rand`.

## How to fix

Set `PGBENCH_RANDOM_SEED` to an unsigned integer for a repeatable run, or to `time` or `rand` for a non-deterministic seed. Unset the variable to fall back to the default. The `--random-seed` command-line option overrides the environment variable if you prefer to pass it explicitly.

## Example

*Illustrative* — a non-numeric seed in the environment.

```
PGBENCH_RANDOM_SEED=abc pgbench -c 4 bench
```

## Related

- [error while setting random seed from --random-seed option](./error-while-setting-random-seed-from-random-seed-option.md)
- [Expecting an unsigned integer, "time" or "rand".](./expecting-an-unsigned-integer-time-or-rand.md)
