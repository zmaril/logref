---
message: "could not create semaphore: error code %lu"
slug: could-not-create-semaphore-error-code
passthrough: false
api: [ereport]
level: [PANIC]
call_sites:
  - "postgres/src/backend/port/win32_sema.c:102"
reproduced: false
---

# `could not create semaphore: error code %lu`

## What it means

On Windows, the server could not create a semaphore it needs for inter-process locking. The `%lu` is the OS error code. Without the semaphore the server cannot coordinate its processes, so it stops.

## When it happens

It happens at server startup on Windows when semaphore creation fails, usually from OS-level handle or resource exhaustion.

## How to fix

This is an OS-level resource failure. Check the Windows host for handle exhaustion or other processes consuming kernel objects, resolve the pressure, and restart the server.

## Example

*Illustrative* — semaphore creation failing at startup.

```text
PANIC:  could not create semaphore: error code 1450
```

## Related

- [could not create semaphores](./could-not-create-semaphores.md)
- [could not create shared memory segment](./could-not-create-shared-memory-segment-bc41b9.md)
