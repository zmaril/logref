---
message: "could not get child thread exit status: %m"
slug: could-not-get-child-thread-exit-status
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2261"
reproduced: false
---

# `could not get child thread exit status: %m`

## What it means

On Windows, `pg_basebackup` waited for its WAL-streaming helper thread to finish and could not read the thread's exit status. The `%m` reason gives the cause. It needs the exit status to know whether streaming succeeded.

## When it happens

It happens at the end of a base backup on Windows when `GetExitCodeThread` fails for the background streaming thread — an unusual operating-system-level failure.

## How to fix

This is a low-level Windows failure at the tail of a backup. Rerun the backup; if it persists, check the host for resource exhaustion or instability. Capture the reported error and the tool output if it recurs on a healthy machine.

## Example

*Illustrative* — the streaming thread's status could not be read.

```text
pg_basebackup: fatal: could not get child thread exit status: Invalid argument
```

## Related

- [could not get exit code from subprocess error code](./could-not-get-exit-code-from-subprocess-error-code.md)
- [could not initiate base backup](./could-not-initiate-base-backup.md)
