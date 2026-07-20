---
message: "\\%s: could not read value for variable"
slug: could-not-read-value-for-variable
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:2671"
reproduced: false
---

# `\%s: could not read value for variable`

## What it means

A `psql` meta-command tried to read a value into a variable and failed. This backs commands that capture query results or shell output into `psql` variables, when the value cannot be read.

## When it happens

It fires when a `psql` command such as `\gset` or a related capture cannot obtain the value it needs to assign — for example the underlying result went away before the read completed.

## How to fix

Check the meta-command that raised it and the query or source feeding it. Make sure the query actually returned the column you are assigning and that the connection was still live. Re-run the command with a query you have verified returns the expected single value.

## Example

*Illustrative* — a capture command could not read its value.

```text
\gset: could not read value for variable
```

## Related

- [could not read result of shell command](./could-not-read-result-of-shell-command.md)
- [could not set printing parameter](./could-not-set-printing-parameter.md)
