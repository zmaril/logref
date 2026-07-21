---
message: "could not set printing parameter \"%s\""
slug: could-not-set-printing-parameter
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/psql/startup.c:621"
reproduced: true
---

# `could not set printing parameter "%s"`

## What it means

`psql` could not apply a printing parameter given at startup. The placeholder is the parameter name. Printing parameters control table output — border style, format, field separators, and the like.

## When it happens

It fires as `psql` starts and processes a `--pset` option (or an equivalent startup setting) whose name or value it does not accept.

## How to fix

Check the `-P`/`--pset` options you passed to `psql`. Use a valid parameter name and value, such as `--pset=format=aligned`. Correct the option and start again; the message names the parameter that was rejected.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__68_bench_psql`); see the reproducer for the triggering workload. It emits:

```text
FATAL:  could not set printing parameter "%s"
```

## Related

- [could not read value for variable](./could-not-read-value-for-variable.md)
- [could not set timer](./could-not-set-timer.md)
