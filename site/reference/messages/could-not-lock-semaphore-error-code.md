---
message: "could not lock semaphore: error code %lu"
slug: could-not-lock-semaphore-error-code
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/win32_sema.c:178"
reproduced: false
---

# `could not lock semaphore: error code %lu`

## What it means

On Windows, the server tried to acquire one of its internal semaphores and the operating-system call failed. The `%lu` value is the Windows error code. Semaphores coordinate access to shared resources between processes.

## When it happens

It fires at the highest severity when a Windows semaphore wait returns an error rather than acquiring the lock — an unusual operating-system-level failure, sometimes tied to resource exhaustion or a handle problem.

## How to fix

This is a low-level Windows failure. Check the host for resource exhaustion and instability, and look up the reported error code for the specific cause. The server will need to be restarted; if it recurs on a healthy machine, capture the log and report it.

## Example

*Illustrative* — a Windows semaphore could not be locked.

```text
PANIC:  could not lock semaphore: error code 6
```

## Related

- [could not map anonymous shared memory](./could-not-map-anonymous-shared-memory.md)
- [could not open lock file](./could-not-open-lock-file.md)
