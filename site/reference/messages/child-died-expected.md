---
message: "child %d died, expected %d"
slug: child-died-expected
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2234"
reproduced: false
---

# `child %d died, expected %d`

## What it means

A parallel client tool waited on a worker process and it exited unexpectedly. The tool reports which child died and which it expected, and it cannot continue without that worker.

## When it happens

It occurs in a tool that manages worker processes, such as a parallel dump or restore, when one of its workers terminates before it should.

## How to fix

Check the tool's earlier output and the server log for the worker's own error, which usually names the real cause such as a connection loss or a query failure. Resolve that, then rerun.

## Example

*Illustrative* — an unexpected worker exit.

```text
fatal: child 3 died, expected 4
```

## Related

- [child process exited abnormally status](./child-process-exited-abnormally-status.md)
- [child worker exited abnormally](./child-worker-exited-abnormally.md)
