---
message: "failed to release reserved memory region (addr=%p): error code %lu"
slug: failed-to-release-reserved-memory-region-addr-error-code
passthrough: false
api: [elog]
level: [FATAL, LOG]
call_sites:
  - "postgres/src/backend/port/win32_shmem.c:437"
  - "postgres/src/backend/port/win32_shmem.c:440"
  - "postgres/src/backend/port/win32_shmem.c:514"
reproduced: false
---

# `failed to release reserved memory region (addr=%p): error code %lu`

## What it means

On Windows, the server could not release a reserved memory region during process setup. The placeholders are the region address and the OS error code. The Windows backend reserves and then frees address-space regions as part of arranging shared memory for a new backend; a failure to release one is an OS-level memory-management error.

## When it happens

Windows-specific memory-management failures during backend startup, sometimes related to address-space layout, antivirus/security software injecting into the process, or memory pressure.

## How to fix

Decode the Windows error code with the system error reference. Investigate software that injects into PostgreSQL processes (antivirus, DLL-injection tools), which commonly disturb the Windows memory layout the server depends on; excluding the data directory and binaries from such tools often helps. Report reproducible cases with the error code and platform.

## Example

*Illustrative* — a failed region release on Windows.

```text
LOG:  failed to release reserved memory region (addr=0x...): error code 487
```

## Related

- [could not create shared memory segment: error code](./could-not-create-shared-memory-segment-error-code.md)
- [could not enable user right error code](./could-not-enable-user-right-error-code.md)
