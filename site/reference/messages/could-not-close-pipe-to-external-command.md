---
message: "could not close pipe to external command: %m"
slug: could-not-close-pipe-to-external-command
passthrough: false
api: [ereport, pg_log_error]
level: [ERROR]
level_runtime_chosen: true
call_sites:
  - "postgres/contrib/basebackup_to_shell/basebackup_to_shell.c:234"
  - "postgres/src/backend/commands/copyfrom.c:1975"
  - "postgres/src/backend/commands/copyto.c:730"
  - "postgres/src/backend/libpq/be-secure-common.c:88"
  - "postgres/src/bin/psql/copy.c:383"
reproduced: false
---

# `could not close pipe to external command: %m`

## What it means

A feature that streams data to an external command (here `basebackup_to_shell`) failed when closing the pipe to that command. The `%m` is the OS error. A failure on close often means the external command exited abnormally or the write end broke.

## When it happens

Using a shell-target base backup (or similar external-command integration) where the invoked command terminated early, returned a nonzero status detected at close, or the pipe was severed.

## How to fix

Check the external command configured for the feature: confirm it exists, is executable, and completes successfully on its own. Inspect its stderr and exit status. A command that dies mid-stream (out of disk, killed) will surface here — fix the underlying command failure.

## Example

*Illustrative* — the target command failed on close.

```text
ERROR:  could not close pipe to external command: Broken pipe
```

## Related

- [could not execute command](./could-not-execute-command.md)
- [could not read COPY data](./could-not-read-copy-data.md)
