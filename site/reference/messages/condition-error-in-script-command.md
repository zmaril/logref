---
message: "condition error in script \"%s\" command %d: %s"
slug: condition-error-in-script-command
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:5941"
reproduced: false
---

# `condition error in script "%s" command %d: %s`

## What it means

`pgbench` failed to evaluate a conditional expression in a custom script command. The `\if`/`\elif` condition could not be computed, so the run aborts.

## When it happens

It happens while running a `pgbench` custom script when a `\if` or `\elif` expression is malformed or references something that cannot be evaluated.

## How to fix

Fix the conditional expression in the named script and command number. Check variable names, operators, and syntax in the `\if`/`\elif` line the message points to.

## Example

*Illustrative* — a bad conditional in a pgbench script.

```text
pgbench: fatal: condition error in script "s1" command 3: ...
```

## Related

- [COPY is not supported in pgbench, aborting](./copy-is-not-supported-in-pgbench-aborting.md)
- [connection to server was lost](./connection-to-server-was-lost.md)
