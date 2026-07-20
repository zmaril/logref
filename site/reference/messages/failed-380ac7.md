---
message: "\\!: failed"
slug: failed-380ac7
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/command.c:5905"
reproduced: false
---

# `\!: failed`

## What it means

In `psql`, a `\!` meta-command ran an external shell command and that command exited with a non-zero (failure) status. The `\!` command shells out to the operating system, and this reports that the shell command itself failed.

## When it happens

It fires from `psql` when you run `\! some-command` (or the bare `\!` to open a subshell) and the invoked command returns a failing exit code.

## How to fix

The failure is in the external command, not in `psql`. Run the same command directly in a shell to see its own error output, and fix that — a wrong path, missing program, bad arguments, or permissions. `psql` only reports that the child process exited non-zero.

## Example

*Illustrative* — the shelled-out command failed.

```
postgres=# \! ls /no/such/dir
```

## Related

- [exceeded maxAllocatedDescs while trying to execute command](./exceeded-maxallocateddescs-while-trying-to-execute-command.md)
- [error: %s() failed: error code %d](./failed-error-code-565002.md)
