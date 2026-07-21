---
message: "could not count number of branches: %s"
slug: could-not-count-number-of-branches
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:5424"
reproduced: true
---

# `could not count number of branches: %s`

## What it means

`pgbench` could not determine how many conditional branches a script contains while parsing it. The `%s` gives the parser's reason. This is an internal step of `pgbench` script compilation.

## When it happens

It happens when `pgbench` compiles a custom script whose conditional structure (`\if`/`\elif`/`\else`/`\endif`) is malformed or unexpectedly deep.

## How to fix

Check the custom `pgbench` script for unbalanced or improperly nested conditional commands. Correct the branch structure and rerun.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__68_bench_psql`); see the reproducer for the triggering workload. It emits:

```text
ERROR:  could not count number of branches: %s
```

## Related

- [could not create connection for initialization](./could-not-create-connection-for-initialization.md)
- [could not create thread](./could-not-create-thread.md)
