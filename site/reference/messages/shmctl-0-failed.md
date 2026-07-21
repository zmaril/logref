---
message: "shmctl(%d, %d, 0) failed: %m"
slug: shmctl-0-failed
passthrough: false
api: [elog]
level: [LOG]
call_sites:
  - "postgres/src/backend/port/sysv_shmem.c:209"
  - "postgres/src/backend/port/sysv_shmem.c:302"
reproduced: false
---

# `shmctl(%d, %d, 0) failed: %m`

## What it means

A `shmctl()` system call the server made against a System V shared memory segment returned an error, so it could not query or change that segment as intended.

## When it happens

It is logged when the server inspects or removes a leftover shared memory segment during startup or cleanup and the operating system rejects the call — for example the segment is owned by another user or was already removed.

## Is this a problem?

This is an operating-system-level condition. Check the errno text at the end of the message, confirm the segment's ownership and permissions, and remove stale segments with `ipcrm` only if you are certain no server is using them. Kernel shared-memory limits and ownership are the usual culprits.

## Example

*Illustrative* — a failing shmctl during segment cleanup.

```text
LOG:  shmctl(163842, 0, 0) failed: Invalid argument
```

## Related

- [reserved shared memory region got incorrect address](./reserved-shared-memory-region-got-incorrect-address-expected.md)
- [all AuxiliaryProcs are in use](./all-auxiliaryprocs-are-in-use.md)
