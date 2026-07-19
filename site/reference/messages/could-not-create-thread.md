---
message: "could not create thread: %m"
slug: could-not-create-thread
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:7461"
reproduced: false
---

# `could not create thread: %m`

## What it means

`pgbench` could not create one of the worker threads it uses to drive its simulated clients. The `%m` reason gives the OS error.

## When it happens

It happens at the start of a `pgbench` run using more than one thread (`-j`), when thread creation fails, usually from resource limits on the host.

## How to fix

Lower the thread count (`-j`), check the host's thread and memory limits, and reduce concurrent load, then rerun.

## Example

*Illustrative* — a benchmark worker thread failing to start.

```text
pgbench: fatal: could not create thread: Resource temporarily unavailable
```

## Related

- [could not create connection for client](./could-not-create-connection-for-client.md)
- [could not create background thread](./could-not-create-background-thread.md)
