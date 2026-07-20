---
message: "%s: could not run shell command: %m"
slug: could-not-run-shell-command
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:2993"
reproduced: false
---

# `%s: could not run shell command: %m`

## What it means

A `pgbench` script tried to run a shell command with `\setshell` or `\shell` and the command could not be started. The trailing text is the operating-system error. This is the launch failure, distinct from failing to read its output.

## When it happens

It fires while a custom `pgbench` script executes a shell meta-command and the operating system cannot spawn the process — a missing program, a bad path, or a permission problem.

## How to fix

Check the command in your `\setshell`/`\shell` line. Make sure the program exists, is on the path or given by absolute path, and is executable. Read the OS error for the exact reason, then correct the command and rerun the benchmark.

## Example

*Illustrative* — the shell command could not be launched.

```text
pgbench: error: could not run shell command: No such file or directory
```

## Related

- [could not read result of shell command](./could-not-read-result-of-shell-command.md)
- [could not start /bin/sh](./could-not-start-bin-sh.md)
