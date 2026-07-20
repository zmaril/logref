---
message: "child worker exited abnormally: %m"
slug: child-worker-exited-abnormally
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/parallel.c:316"
reproduced: false
---

# `child worker exited abnormally: %m`

## What it means

A parallel client tool detected that one of its worker processes exited abnormally. The reported system error follows the message. The tool cannot finish because a worker did not complete its part.

## When it happens

It occurs in tools that run parallel workers, such as `pg_dump` or `pg_restore`, when a worker terminates unexpectedly.

## How to fix

Check the appended system error and the server log for the worker's cause. Resolve the underlying failure, for example a connection drop or resource limit, then rerun.

## Example

*Illustrative* — an abnormal worker exit.

```text
fatal: child worker exited abnormally: Broken pipe
```

## Related

- [child died expected](./child-died-expected.md)
- [child thread exited with error](./child-thread-exited-with-error.md)
