---
message: "could not create shared memory segment: error code %lu"
slug: could-not-create-shared-memory-segment-error-code
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/win32_shmem.c:312"
  - "postgres/src/backend/port/win32_shmem.c:348"
  - "postgres/src/backend/port/win32_shmem.c:373"
reproduced: false
---

# `could not create shared memory segment: error code %lu`

## What it means

On Windows, the server could not create a shared-memory segment during startup. The placeholder is the OS error code. The shared-memory segment holds the cluster's buffers and shared state; without it the postmaster cannot start.

## When it happens

Insufficient memory or address space, a conflicting existing segment, or Windows-specific limits/permissions preventing the mapping — often when shared-memory settings (`shared_buffers`) are too large for the machine.

## How to fix

Decode the Windows error code with the system error reference. Reduce `shared_buffers` if the machine cannot back the requested size, ensure enough RAM/page file, and check for a stale segment from a prior crash (a clean reboot clears it). Confirm the service account has the rights it needs.

## Example

*Illustrative* — Windows shared-memory creation failing.

```text
FATAL:  could not create shared memory segment: error code 1450
```

## Related

- [could not enable user right error code](./could-not-enable-user-right-error-code.md)
- [failed to release reserved memory region addr error code](./failed-to-release-reserved-memory-region-addr-error-code.md)
