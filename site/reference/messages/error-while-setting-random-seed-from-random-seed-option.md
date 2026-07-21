---
message: "error while setting random seed from --random-seed option"
slug: error-while-setting-random-seed-from-random-seed-option
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:7085"
reproduced: false
---

# `error while setting random seed from --random-seed option`

## What it means

`pgbench` could not use the value passed to its `--random-seed` command-line option to seed the random-number generator. The value was not one `pgbench` accepts.

## When it happens

It fires at `pgbench` startup when `--random-seed` is given something other than an unsigned integer or the keywords `time` or `rand`.

## How to fix

Pass `--random-seed` an unsigned integer to make a run reproducible, or `time` or `rand` for a fresh seed each run. Omit the option to use the default seeding behaviour.

## Example

*Illustrative* — an invalid seed on the command line.

```
pgbench --random-seed=abc -c 4 bench
```

## Related

- [error while setting random seed from PGBENCH_RANDOM_SEED environment variable](./error-while-setting-random-seed-from-pgbench-random-seed-environment-variable.md)
- [Expecting an unsigned integer, "time" or "rand".](./expecting-an-unsigned-integer-time-or-rand.md)
