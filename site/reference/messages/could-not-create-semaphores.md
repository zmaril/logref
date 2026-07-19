---
message: "could not create semaphores: %m"
slug: could-not-create-semaphores
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/sysv_sema.c:134"
reproduced: false
---

# `could not create semaphores: %m`

## What it means

The server could not create the System V semaphores it needs for inter-process locking. The `%m` reason gives the OS error. Without them the server cannot start.

## When it happens

It happens at startup on Unix-like systems when semaphore creation fails, usually because the kernel's semaphore limits are exhausted or set too low.

## How to fix

Raise the kernel's semaphore limits (the `SEMMNS`/`SEMMNI`-family settings; on Linux the `kernel.sem` sysctl). Another server or application may also be consuming the available semaphores — free them and restart.

## Example

*Illustrative* — semaphore creation failing at startup.

```text
FATAL:  could not create semaphores: No space left on device
```

## Related

- [could not create semaphore: error code](./could-not-create-semaphore-error-code.md)
- [could not create shared memory segment](./could-not-create-shared-memory-segment-bc41b9.md)
