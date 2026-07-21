---
message: "at most %d SQL scripts are allowed"
slug: at-most-sql-scripts-are-allowed
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:6297"
reproduced: false
---

# `at most %d SQL scripts are allowed`

## What it means

A benchmark run specified more script files than the tool permits, exceeding its fixed limit on the number of scripts.

## When it happens

It occurs in `pgbench` when the combined number of `-f`/`-b` scripts passed exceeds the maximum it supports.

## How to fix

Reduce the number of scripts to within the stated limit. Combine scripts, run fewer at once, or split the workload across separate `pgbench` invocations.

## Example

*Illustrative* — too many pgbench scripts.

```text
at most 128 SQL scripts are allowed
```

## Related

- [ambiguous builtin name: builtin scripts found for prefix](./ambiguous-builtin-name-builtin-scripts-found-for-prefix.md)
- [-1 can only be used in non-interactive mode](./1-can-only-be-used-in-non-interactive-mode.md)
