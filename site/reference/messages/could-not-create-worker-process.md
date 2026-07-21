---
message: "could not create worker process: %m"
slug: could-not-create-worker-process
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/parallel.c:1016"
  - "postgres/src/bin/pg_upgrade/parallel.c:128"
  - "postgres/src/bin/pg_upgrade/parallel.c:236"
reproduced: false
---

# `could not create worker process: %m`

## What it means

A tool that parallelizes work (here `pg_dump`'s parallel mode) could not spawn a worker process. The placeholder is the OS error. Parallel dump/restore forks worker processes; if the OS refuses, the requested parallelism cannot be set up.

## When it happens

Process/resource limits reached (`ulimit -u`, memory), or an OS-level failure to fork — common on constrained hosts or with a very high `--jobs` value.

## How to fix

Read the appended OS error. Lower the parallel job count (`--jobs`), raise the process/memory limits for the user, or free resources on the host, then re-run. If the machine cannot support the requested parallelism, run with fewer workers.

## Example

*Illustrative* — parallel dump failing to fork a worker.

```text
pg_dump: error: could not create worker process: Resource temporarily unavailable
```

## Related

- [could not create worker thread](./could-not-create-worker-thread.md)
- [could not attach to dynamic shared area](./could-not-attach-to-dynamic-shared-area.md)
