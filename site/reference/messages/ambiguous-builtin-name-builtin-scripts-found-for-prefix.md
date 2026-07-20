---
message: "ambiguous builtin name: %d builtin scripts found for prefix \"%s\""
slug: ambiguous-builtin-name-builtin-scripts-found-for-prefix
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:6242"
reproduced: false
---

# `ambiguous builtin name: %d builtin scripts found for prefix "%s"`

## What it means

A built-in script was selected by a name prefix that matches more than one built-in script, so the tool cannot tell which one you meant.

## When it happens

It occurs in `pgbench` when `-b` (builtin) is given a prefix that is not unique among the built-in scripts.

## How to fix

Give a longer, unambiguous prefix or the full built-in script name. Run `pgbench -b list` to see the available built-in scripts and their names, then pick one that identifies a single script.

## Example

*Illustrative* — an ambiguous pgbench builtin prefix.

```text
ambiguous builtin name: 2 builtin scripts found for prefix "t"
```

## Related

- [at most SQL scripts are allowed](./at-most-sql-scripts-are-allowed.md)
- [an unlimited number of transaction tries can only be used with --latency-limit](./an-unlimited-number-of-transaction-tries-can-only-be-used-with-latency-limit-or.md)
