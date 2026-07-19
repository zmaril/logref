---
message: "Expecting an unsigned integer, \"time\" or \"rand\"."
slug: expecting-an-unsigned-integer-time-or-rand
passthrough: false
api: [pg_log_error_detail]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:6714"
reproduced: false
---

# `Expecting an unsigned integer, "time" or "rand".`

## What it means

A `pgbench` detail line explaining a random-seed error. It states that the seed value must be an unsigned integer or one of the keywords `time` or `rand`, and the given value was none of those.

## When it happens

It accompanies a `pgbench` random-seed failure when `--random-seed` or `PGBENCH_RANDOM_SEED` is set to an unacceptable value.

## How to fix

Set the seed to an unsigned integer for a reproducible run, or to `time` or `rand` for a non-deterministic one. Fix whichever source supplied the bad value — the option or the environment variable.

## Example

*Illustrative* — the accompanying detail line.

```
Expecting an unsigned integer, "time" or "rand".
```

## Related

- [error while setting random seed from --random-seed option](./error-while-setting-random-seed-from-random-seed-option.md)
- [exponential parameter must be greater than zero (not)](./exponential-parameter-must-be-greater-than-zero-not.md)
