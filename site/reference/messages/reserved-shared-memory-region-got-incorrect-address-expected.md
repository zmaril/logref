---
message: "reserved shared memory region got incorrect address %p, expected %p"
slug: reserved-shared-memory-region-got-incorrect-address-expected
passthrough: false
api: [elog]
level: [LOG]
call_sites:
  - "postgres/src/backend/port/win32_shmem.c:600"
  - "postgres/src/backend/port/win32_shmem.c:616"
reproduced: false
---

# `reserved shared memory region got incorrect address %p, expected %p`

## What it means

On Windows, a child backend mapped the shared memory region at a different base address than the postmaster reserved for it, so pointers into shared memory would not line up between processes.

## When it happens

It is logged when a newly started backend's reserved memory region does not land at the expected address, usually because another DLL or an anti-virus/injection hook occupied that address range in the child.

## Is this a problem?

This is an environment-level problem, not a query fault. The backend that hit it cannot use shared memory and will not start. Investigate software that injects into Postgres processes (anti-virus, monitoring hooks) and consider excluding the server from it; the address-space layout must match across the postmaster and its children.

## Example

*Illustrative* — a child backend mapping shared memory at the wrong address.

```text
LOG:  reserved shared memory region got incorrect address 0x0000000002000000, expected 0x0000000001000000
```

## Related

- [shmctl(%d, %d, 0) failed](./shmctl-0-failed.md)
- [all AuxiliaryProcs are in use](./all-auxiliaryprocs-are-in-use.md)
