---
message: "could not try-lock semaphore: error code %lu"
slug: could-not-try-lock-semaphore-error-code
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/win32_sema.c:228"
reproduced: false
---

# `could not try-lock semaphore: error code %lu`

## What it means

On Windows, the server could not perform a non-blocking attempt to acquire a semaphore. The trailing text is the Windows error code. Semaphores back the server's internal locking primitives on Windows.

## When it happens

It fires inside the Windows semaphore layer when a try-lock call on a semaphore object fails, which is a low-level operating-system failure.

## How to fix

This is an OS-level failure in the locking machinery, not a query problem. It usually indicates handle exhaustion or an OS resource limit. Check the host for resource pressure and the surrounding log for context, and capture the Windows error code if it recurs on a healthy host.

## Example

*Illustrative* — a semaphore try-lock failed on Windows.

```text
FATAL:  could not try-lock semaphore: error code 6
```

## Related

- [could not unlock semaphore](./could-not-unlock-semaphore-error-code.md)
- [could not reset socket waiting event](./could-not-reset-socket-waiting-event-error-code.md)
