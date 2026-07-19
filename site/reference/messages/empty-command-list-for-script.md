---
message: "empty command list for script \"%s\""
slug: empty-command-list-for-script
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:6294"
reproduced: false
---

# `empty command list for script "%s"`

## What it means

`pgbench` parsed a benchmark script that contained no runnable commands. The placeholder is the script name. A script must have at least one SQL or meta command.

## When it happens

It fires at `pgbench` startup when a custom script file (via `-f`) is empty or contains only comments and blank lines.

## How to fix

Put at least one SQL command in the script file. Check that the file path is correct and the file is not empty or entirely commented out.

## Example

*Illustrative* — an empty pgbench script.

```text
pgbench: error: empty command list for script "myscript.sql"
```

## Related

- [duration must be a multiple of aggregation interval](./duration-must-be-a-multiple-of-aggregation-interval.md)
- [empty range given to random](./empty-range-given-to-random.md)
