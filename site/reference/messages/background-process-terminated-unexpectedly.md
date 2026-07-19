---
message: "background process terminated unexpectedly"
slug: background-process-terminated-unexpectedly
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1045"
reproduced: false
---

# `background process terminated unexpectedly`

## What it means

A background process that a client operation depended on exited without warning, so the operation cannot continue. The wait routine treats the disappearance as a fatal condition for the waiting session.

## When it happens

It typically appears when a supporting worker crashes or is killed — for example a parallel worker or a subsystem background process — during an operation that waits on it.

## How to fix

Look for the background process's own exit message earlier in the server log; that entry names the real cause, often an out-of-memory kill or a crash. Address that root cause: check the OOM killer, resource limits, and any crashing extension, then retry.

## Example

*Illustrative* — a waiting session losing its worker.

```text
FATAL:  background process terminated unexpectedly
```

## Related

- [backup failed](./backup-failed.md)
- [bogus data in lock file](./bogus-data-in-lock-file.md)
