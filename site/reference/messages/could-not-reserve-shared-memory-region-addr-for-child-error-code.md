---
message: "could not reserve shared memory region (addr=%p) for child %p: error code %lu"
slug: could-not-reserve-shared-memory-region-addr-for-child-error-code
passthrough: false
api: [elog]
level: [LOG]
call_sites:
  - "postgres/src/backend/port/win32_shmem.c:588"
  - "postgres/src/backend/port/win32_shmem.c:610"
reproduced: false
---

# `could not reserve shared memory region (addr=%p) for child %p: error code %lu`

## What it means

On Windows, the postmaster could not reserve the shared-memory address region in a child process at the same address the parent uses; the error code is the operating-system reason.

## When it happens

It arises when launching a backend on Windows and the child's address space cannot reserve the region — often caused by a DLL or antivirus loading at a conflicting address (address-space layout interference).

## Is this a problem?

This is a known Windows interaction. Identify and exclude interfering software (antivirus, injected DLLs) from the PostgreSQL processes; the message names the error code. The postmaster retries child creation.

## Example

*Illustrative* — a failed shared-memory reservation on Windows.

```text
LOG:  could not reserve shared memory region (addr=0000000002000000) for child 00000000000004D0: error code 487
```

## Related

- [could not close handle to shared memory: error code %lu](./could-not-close-handle-to-shared-memory-error-code.md)
- [could not resize shared memory segment "%s" to %zu bytes: %m](./could-not-resize-shared-memory-segment-to-bytes.md)
