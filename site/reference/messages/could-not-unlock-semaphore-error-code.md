---
message: "could not unlock semaphore: error code %lu"
slug: could-not-unlock-semaphore-error-code
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/win32_sema.c:198"
reproduced: false
---

# `could not unlock semaphore: error code %lu`

## What it means

On Windows, the server could not release a semaphore. The trailing text is the Windows error code. Releasing a semaphore is part of the server's internal locking on Windows.

## When it happens

It fires inside the Windows semaphore layer when releasing a semaphore object fails, which is an unexpected operating-system-level failure.

## How to fix

This is a low-level OS failure in the locking machinery rather than anything a query caused. It typically points at handle exhaustion or an OS problem. Check the host's resource limits and the surrounding log, and capture the error code if it persists on a healthy system.

## Example

*Illustrative* — a semaphore release failed on Windows.

```text
FATAL:  could not unlock semaphore: error code 6
```

## Related

- [could not try-lock semaphore](./could-not-try-lock-semaphore-error-code.md)
- [could not reset socket waiting event](./could-not-reset-socket-waiting-event-error-code.md)
