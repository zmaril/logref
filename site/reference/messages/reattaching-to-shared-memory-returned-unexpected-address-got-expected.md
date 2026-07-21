---
message: "reattaching to shared memory returned unexpected address (got %p, expected %p)"
slug: reattaching-to-shared-memory-returned-unexpected-address-got-expected
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/sysv_shmem.c:918"
  - "postgres/src/backend/port/win32_shmem.c:448"
reproduced: false
---

# `reattaching to shared memory returned unexpected address (got %p, expected %p)`

## What it means

On Windows, a child backend re-attaching the server's shared-memory segment received a different base address than the postmaster used, so pointers into shared memory would be invalid. The placeholders are the addresses obtained and expected. The backend cannot safely continue.

## When it happens

It arises on Windows when address-space layout randomization or another process's allocation prevents the child from mapping shared memory at the same address as the parent — a known Windows fork-emulation hazard.

## How to fix

Retrying the connection often succeeds, since the conflicting mapping is transient. Persistent failures are typically mitigated by disabling ASLR for the Postgres binaries or addressing whatever DLL/allocation is claiming the address; consult the Windows-specific guidance for your version.

## Example

*Illustrative* — a Windows backend re-mapping shared memory at the wrong address.

```text
FATAL:  reattaching to shared memory returned unexpected address (got 0x1f0000, expected 0x200000)
```

## Related

- [pre-existing shared memory block (key %lu, ID %lu) is still in use](./pre-existing-shared-memory-block-key-id-is-still-in-use.md)
- [out of shared memory (%zu bytes requested)](./out-of-shared-memory-bytes-requested.md)
