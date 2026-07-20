---
message: "%s: could not read result of shell command"
slug: could-not-read-result-of-shell-command
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:2987"
reproduced: false
---

# `%s: could not read result of shell command`

## What it means

A `pgbench` script ran a shell command with `\setshell` and could not read its output. `pgbench` captures the command's standard output to assign a variable, and that read failed.

## When it happens

It fires while a custom `pgbench` script executes a `\setshell` meta-command and the spawned command produces no readable output or the pipe from it fails.

## How to fix

Check that the shell command in your `\setshell` line runs and prints a single value to standard output. A command that fails, prints nothing, or writes only to standard error triggers this. Test the command on its own first, then confirm the variable assignment in the script.

## Example

*Illustrative* — a \setshell command produced no output.

```text
pgbench: error: could not read result of shell command
```

## Related

- [could not run shell command](./could-not-run-shell-command.md)
- [could not start /bin/sh](./could-not-start-bin-sh.md)
