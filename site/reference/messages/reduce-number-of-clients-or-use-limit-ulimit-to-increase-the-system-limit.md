---
message: "Reduce number of clients, or use limit/ulimit to increase the system limit."
slug: reduce-number-of-clients-or-use-limit-ulimit-to-increase-the-system-limit
passthrough: false
api: [pg_log_error_hint]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:6887"
  - "postgres/src/bin/pgbench/pgbench.c:6898"
reproduced: false
---

# `Reduce number of clients, or use limit/ulimit to increase the system limit.`

## What it means

A hint, usually attached to a resource-exhaustion error from a client tool such as `pgbench`. It advises lowering concurrency or raising an operating-system resource limit so the tool can obtain the descriptors or handles it needs.

## When it happens

It appears when a tool cannot create as many connections, file descriptors, or threads as requested — commonly hitting the per-process open-files (`ulimit -n`) or thread limits at high client counts.

## How to fix

Either reduce the requested concurrency (fewer clients/threads) or raise the relevant OS limit (`ulimit -n`, or the equivalent) before running. On systemd-managed services, adjust `LimitNOFILE`. The message names both levers because the right one depends on your setup.

## Example

*Illustrative* — a hint following a client-side resource limit.

```text
HINT:  Reduce number of clients, or use limit/ulimit to increase the system limit.
```

## Related

- [socket file descriptor out of range for select(): %d](./socket-file-descriptor-out-of-range-for-select.md)
- [out of background worker slots](./out-of-background-worker-slots.md)
