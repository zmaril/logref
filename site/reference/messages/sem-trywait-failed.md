---
message: "sem_trywait failed: %m"
slug: sem-trywait-failed
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/posix_sema.c:302"
  - "postgres/src/backend/port/posix_sema.c:377"
reproduced: false
---

# `sem_trywait failed: %m`

## What it means

Internal error. A non-blocking wait on a semaphore (`sem_trywait`) returned an unexpected failure. The placeholder carries the system error. Postgres uses semaphores for low-level synchronization between processes.

## When it happens

It fires from the semaphore layer when the OS reports an error that the code did not expect from a try-wait. It usually points to a system-level problem (exhausted semaphores, a kernel/resource fault) rather than SQL.

## How to fix

This is a low-level guard. Check the system error in the message and OS semaphore limits (SysV/POSIX semaphores). Persistent failures indicate an OS resource or configuration issue on the host; capture the log and system state.

## Example

*Illustrative* — a semaphore try-wait failing at the OS level.

```text
FATAL:  sem_trywait failed: Invalid argument
```

## Related

- [out of shared memory (%zu bytes requested)](./out-of-shared-memory-bytes-requested.md)
- [timeout index %d out of range 0..%d](./timeout-index-out-of-range-0.md)
