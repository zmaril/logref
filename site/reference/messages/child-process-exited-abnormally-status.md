---
message: "child process exited abnormally: status %d"
slug: child-process-exited-abnormally-status
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/parallel.c:301"
reproduced: false
---

# `child process exited abnormally: status %d`

## What it means

A client tool ran a child process and it exited with a non-zero or signal status. The tool cannot proceed because the child's work did not complete successfully.

## When it happens

It occurs in tools that spawn helper processes, such as `pg_upgrade` running the old or new server binaries, when a spawned process exits abnormally.

## How to fix

Look at the tool's log and any output from the child for the specific failure. Fix the underlying problem, for example a misconfigured binary path or a server that failed to start, then rerun.

## Example

*Illustrative* — an abnormal child exit.

```text
fatal: child process exited abnormally: status 1
```

## Related

- [child died expected](./child-died-expected.md)
- [child thread exited with error](./child-thread-exited-with-error.md)
