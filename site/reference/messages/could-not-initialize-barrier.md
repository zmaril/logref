---
message: "could not initialize barrier: %m"
slug: could-not-initialize-barrier
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:7450"
reproduced: false
---

# `could not initialize barrier: %m`

## What it means

`pgbench` tried to create a thread barrier — a synchronization point where its worker threads wait for each other — and the operating system call failed. The `%m` reason gives the cause.

## When it happens

It happens when starting a multi-threaded `pgbench` run, when the barrier for coordinating the client threads cannot be initialized — usually a resource limit or a platform without the needed threading support.

## How to fix

Check the machine's thread and resource limits and rerun, or reduce the number of threads (`-j`). On platforms lacking the required barrier support, running with a single thread avoids the barrier entirely.

## Example

*Illustrative* — the pgbench thread barrier could not be created.

```text
pgbench: fatal: could not initialize barrier: Resource temporarily unavailable
```

## Related

- [could not generate random seed](./could-not-generate-random-seed.md)
- [could not initialize cache](./could-not-initialize-cache.md)
