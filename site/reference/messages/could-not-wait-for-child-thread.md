---
message: "could not wait for child thread: %m"
slug: could-not-wait-for-child-thread
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2256"
reproduced: false
---

# `could not wait for child thread: %m`

## What it means

On the Windows build, `pg_basebackup` could not wait for its background child thread. The trailing text is the operating-system error. Windows builds use a thread rather than a separate process for the background worker.

## When it happens

It fires as `pg_basebackup` completes on Windows and cannot join its worker thread, which points at an unexpected OS-level failure around the thread.

## How to fix

Look earlier in the output for the worker thread's own error; this is usually a follow-on from it failing. Fix the underlying cause — a lost server connection or a target-disk problem — and rerun the backup.

## Example

*Illustrative* — joining the child thread failed.

```text
pg_basebackup: error: could not wait for child thread: Invalid argument
```

## Related

- [could not wait for child process](./could-not-wait-for-child-process.md)
- [could not send command to background pipe](./could-not-send-command-to-background-pipe.md)
