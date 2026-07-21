---
message: "could not close handle to shared memory: error code %lu"
slug: could-not-close-handle-to-shared-memory-error-code
passthrough: false
api: [elog]
level: [LOG]
call_sites:
  - "postgres/src/backend/port/win32_shmem.c:357"
  - "postgres/src/backend/port/win32_shmem.c:534"
reproduced: false
---

# `could not close handle to shared memory: error code %lu`

## What it means

On Windows, the server could not close a handle to a shared-memory object; the reported error code is the operating-system reason.

## When it happens

It arises during shared-memory teardown on Windows when the `CloseHandle` call fails. It is logged as a cleanup anomaly rather than a fatal condition.

## Is this a problem?

This is usually harmless at shutdown or worker teardown. If it recurs, check for Windows resource or antivirus interference with the server's shared-memory objects, and capture the error code to report it.

## Example

*Illustrative* — a failed shared-memory handle close on Windows.

```text
LOG:  could not close handle to shared memory: error code 6
```

## Related

- [could not reserve shared memory region (addr=%p) for child %p: error code %lu](./could-not-reserve-shared-memory-region-addr-for-child-error-code.md)
- [could not resize shared memory segment "%s" to %zu bytes: %m](./could-not-resize-shared-memory-segment-to-bytes.md)
