---
message: "socket file descriptor out of range for select(): %d"
slug: socket-file-descriptor-out-of-range-for-select
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:8028"
  - "postgres/src/fe_utils/parallel_slot.c:325"
reproduced: false
---

# `socket file descriptor out of range for select(): %d`

## What it means

A socket's file-descriptor number is too large to be used with the `select()` system call, which can only handle descriptors below a fixed limit. The placeholder is the descriptor number. The connection cannot be monitored with `select()`.

## When it happens

It arises when a process has opened so many files/sockets that a new socket's descriptor exceeds `FD_SETSIZE` — typically at very high connection or file-descriptor counts, on platforms that still use `select()` in that path.

## How to fix

Lower the number of concurrently open descriptors: reduce connections/`max_files_per_process`, or raise the OS file-descriptor limit and connection pooling so individual processes stay under the `select()` ceiling. Fewer simultaneous sockets per process avoids the limit.

## Example

*Illustrative* — a socket descriptor beyond the select() limit.

```text
ERROR:  socket file descriptor out of range for select(): 1088
```

## Related

- [Reduce number of clients, or use limit/ulimit to increase the system limit.](./reduce-number-of-clients-or-use-limit-ulimit-to-increase-the-system-limit.md)
- [out of background worker slots](./out-of-background-worker-slots.md)
