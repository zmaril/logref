---
message: "could not create ShmemIndex entry for data structure \"%s\""
slug: could-not-create-shmemindex-entry-for-data-structure
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OUT_OF_MEMORY
    code: "53200"
call_sites:
  - "postgres/src/backend/storage/ipc/shmem.c:527"
reproduced: false
---

# `could not create ShmemIndex entry for data structure "%s"`

## What it means

The server could not register a named entry in its shared-memory index for one of its internal data structures. The `%s` names the structure. This means the shared-memory area ran out of room for the entry.

## When it happens

It fires during startup or when an extension requests shared memory, when the shared-memory index has no free space for a new named entry — typically because an extension asked for more shared memory than was reserved.

## How to fix

If a custom extension triggers this, it likely under-reserved shared memory in its `shmem_request_hook`. Check the extension's shared-memory sizing. For the core case, this points at an internal accounting problem worth reporting with a reproducible case.

## Example

*Illustrative* — the shared-memory index full during registration.

```text
ERROR:  could not create ShmemIndex entry for data structure "MyExtensionState"
```

## Related

- [could not create shared memory segment](./could-not-create-shared-memory-segment-bc41b9.md)
- [could not create semaphores](./could-not-create-semaphores.md)
