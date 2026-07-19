---
message: "-1 can only be used in non-interactive mode"
slug: 1-can-only-be-used-in-non-interactive-mode
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/psql/startup.c:226"
reproduced: false
---

# `-1 can only be used in non-interactive mode`

## What it means

A command-line option was given the value `-1`, which selects a single-transaction or run-once behavior that is only meaningful when input is not being typed interactively.

## When it happens

It is raised as a fatal startup error by a client tool when `-1` is combined with an interactive session instead of a script or piped input.

## How to fix

Use `-1` only with non-interactive input — supply a file with `-f`, pipe a script in, or pass the command with `-c`. Remove `-1` if you want an interactive session. Check the tool's help for how `-1` interacts with its input modes.

## Example

*Illustrative* — combining -1 with an interactive session.

```text
psql: -1 can only be used in non-interactive mode
```

## Related

- [at most SQL scripts are allowed](./at-most-sql-scripts-are-allowed.md)
- [an unlimited number of transaction tries can only be used with --latency-limit](./an-unlimited-number-of-transaction-tries-can-only-be-used-with-latency-limit-or.md)
