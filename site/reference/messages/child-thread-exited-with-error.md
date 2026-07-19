---
message: "child thread exited with error %u"
slug: child-thread-exited-with-error
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2264"
reproduced: false
---

# `child thread exited with error %u`

## What it means

A client tool that uses worker threads found one of them exited with an error. On Windows builds the tool runs workers as threads, and a thread failure stops the operation.

## When it happens

It occurs in tools such as a parallel `pg_dump` or `pg_restore` on Windows when a worker thread encounters an error.

## How to fix

Review the tool's output and the server log for the worker's specific error. Address the underlying cause, for example a failed query or a lost connection, then rerun.

## Example

*Illustrative* — a worker thread error.

```text
fatal: child thread exited with error 1
```

## Related

- [child process exited abnormally status](./child-process-exited-abnormally-status.md)
- [child worker exited abnormally](./child-worker-exited-abnormally.md)
