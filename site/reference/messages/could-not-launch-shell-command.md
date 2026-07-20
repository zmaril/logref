---
message: "%s: could not launch shell command"
slug: could-not-launch-shell-command
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:2972"
  - "postgres/src/bin/pgbench/pgbench.c:2981"
reproduced: false
---

# `%s: could not launch shell command`

## What it means

`pgbench` could not start a shell command requested by a `\shell` or `\setshell` meta-command in a custom script. The message is prefixed with the script context.

## When it happens

The command named in the script could not be executed — a missing program, a bad path, or a `fork`/`exec` failure on the client host running `pgbench`.

## How to fix

Check the command in the `\shell`/`\setshell` line exists on the client host and is executable, and that the path is correct. Test the command in a plain shell first, then rerun `pgbench`.

## Example

*Illustrative* — a \setshell command that does not exist.

```text
pgbench: error: could not launch shell command
```

## Related

- [could not save history to file](./could-not-save-history-to-file.md)
- [failed to start transaction](./failed-to-start-transaction.md)
