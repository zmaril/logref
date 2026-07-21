---
message: "could not reattach to shared memory (key=%d, addr=%p): %m"
slug: could-not-reattach-to-shared-memory-key-addr
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/sysv_shmem.c:915"
reproduced: false
---

# `could not reattach to shared memory (key=%d, addr=%p): %m`

## What it means

A newly started backend could not reattach the main shared-memory segment at the address the postmaster used. On platforms that re-exec each backend, every process must map shared memory at the same address, and this one could not.

## When it happens

It fires at backend startup, most often on Windows or under EXEC_BACKEND builds, when something else has already occupied the required address range in the new process — commonly address-space layout randomization or an injected library.

## How to fix

This is a known platform hazard rather than a data problem. On Windows it is usually transient under load; retrying the connection often succeeds. If it is frequent, look for antivirus or other software injecting DLLs into Postgres processes, and consider the documented mitigations for ASLR interfering with the fixed shared-memory address.

## Example

*Illustrative* — a backend could not remap shared memory.

```text
FATAL:  could not reattach to shared memory (key=5432001, addr=0x7f00000000): Invalid argument
```

## Related

- [could not reattach to shared memory (Windows error code)](./could-not-reattach-to-shared-memory-key-addr-error-code.md)
- [could not reserve memory region](./could-not-reserve-memory-region-error-code.md)
