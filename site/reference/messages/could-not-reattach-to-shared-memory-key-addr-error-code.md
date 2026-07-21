---
message: "could not reattach to shared memory (key=%p, addr=%p): error code %lu"
slug: could-not-reattach-to-shared-memory-key-addr-error-code
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/win32_shmem.c:445"
reproduced: false
---

# `could not reattach to shared memory (key=%p, addr=%p): error code %lu`

## What it means

The Windows build of a backend could not reattach the main shared-memory mapping at the postmaster's address. The placeholders are the key and address, and the trailing text is the Windows error code.

## When it happens

It fires at backend startup on Windows when the fixed address the shared-memory segment must occupy is already taken in the new process, so the mapping cannot be placed where every backend expects it.

## How to fix

This is the Windows form of the reattach hazard. It is often transient under load, so a retry may connect. When it recurs, the usual culprit is another product injecting a DLL into Postgres processes and disturbing the address space; identify and exclude that software. See the documented ASLR mitigations for the fixed shared-memory address.

## Example

*Illustrative* — the Windows reattach failed.

```text
FATAL:  could not reattach to shared memory (key=0x0130, addr=0x00000000): error code 487
```

## Related

- [could not reattach to shared memory](./could-not-reattach-to-shared-memory-key-addr.md)
- [could not reserve memory region](./could-not-reserve-memory-region-error-code.md)
