---
message: "shmdt(%p) failed: %m"
slug: shmdt-failed
passthrough: false
api: [elog]
level: [LOG]
call_sites:
  - "postgres/src/backend/port/sysv_shmem.c:291"
  - "postgres/src/backend/port/sysv_shmem.c:325"
  - "postgres/src/backend/port/sysv_shmem.c:841"
  - "postgres/src/backend/port/sysv_shmem.c:982"
reproduced: false
---

# `shmdt(%p) failed: %m`

## What it means

The server's call to `shmdt()` — which detaches a System V shared memory segment from the process — failed. The placeholders are the segment address and the OS error. It is logged at `LOG` level during shared-memory cleanup; a failed detach is unusual because the segment was attached successfully earlier.

## When it happens

It is rare and points to an OS-level shared-memory inconsistency — for example an address already detached, or kernel state disturbed by external interference with the cluster's System V segments.

## Is this a problem?

Read the appended OS error. In isolation it does not corrupt data and often needs no action, but repeated occurrences suggest an OS shared-memory problem worth investigating (kernel logs, `ipcs` output, external tools touching the segments). Report reproducible cases with the OS error and platform.

## Example

*Illustrative* — a failed shared-memory detach.

```text
LOG:  shmdt(0x7f..) failed: Invalid argument
```

## Related

- [could not unmap shared memory segment](./could-not-unmap-shared-memory-segment.md)
- [could not stat shared memory segment](./could-not-stat-shared-memory-segment.md)
