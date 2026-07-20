---
message: "could not create shared memory segment: %m"
slug: could-not-create-shared-memory-segment-bc41b9
passthrough: false
api: [ereport]
level: [FATAL]
call_sites:
  - "postgres/src/backend/port/sysv_shmem.c:224"
reproduced: false
---

# `could not create shared memory segment: %m`

## What it means

The server could not create the shared-memory segment it needs for its buffers and shared state. The `%m` reason gives the OS error. Without shared memory the server cannot start.

## When it happens

It happens at startup when the OS refuses the shared-memory request, usually because a kernel shared-memory limit is too small or the system is out of memory.

## How to fix

Check the kernel's shared-memory limits (`SHMMAX`/`SHMALL`) against the server's needs, and confirm the host has enough free memory. Lowering `shared_buffers` reduces the request. Earlier log lines show the requested size.

## Example

*Illustrative* — a shared-memory request the kernel refuses.

```text
FATAL:  could not create shared memory segment: Invalid argument
```

## Related

- [could not create ShmemIndex entry for data structure](./could-not-create-shmemindex-entry-for-data-structure.md)
- [could not create semaphores](./could-not-create-semaphores.md)
