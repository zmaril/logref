---
message: "could not read from ready pipe: %m"
slug: could-not-read-from-ready-pipe
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:489"
reproduced: false
---

# `could not read from ready pipe: %m`

## What it means

`pg_basebackup` failed to read from the internal pipe it uses to coordinate its background worker. The pipe carries readiness signals between the main process and the child that streams the base backup, and the read returned an error.

## When it happens

It fires while `pg_basebackup` is running in its default fork-a-worker mode, if the operating system tears down the pipe or the child exits unexpectedly. The trailing text is the OS error for the failed read.

## How to fix

This almost always means the background worker died. Look just above this line in the output for the real cause — a network drop from the server, a disk-full condition on the target, or the process being killed. Fix that condition and rerun the backup. If the worker is being killed for memory, check the host's resource limits.

## Example

*Illustrative* — the streaming child exited and the pipe read failed.

```text
pg_basebackup: error: could not read from ready pipe: Broken pipe
```

## Related

- [could not send command to background pipe](./could-not-send-command-to-background-pipe.md)
- [could not wait for child process](./could-not-wait-for-child-process.md)
