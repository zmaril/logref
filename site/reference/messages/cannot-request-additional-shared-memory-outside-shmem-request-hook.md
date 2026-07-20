---
message: "cannot request additional shared memory outside shmem_request_hook"
slug: cannot-request-additional-shared-memory-outside-shmem-request-hook
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/storage/ipc/ipci.c:48"
reproduced: false
---

# `cannot request additional shared memory outside shmem_request_hook`

## What it means

An internal guard fired: code tried to reserve additional shared memory outside the `shmem_request_hook`. Extensions must request shared memory during that hook, before the segment is sized, so a later request is refused.

## When it happens

It is reached when an extension calls `RequestAddinShmemSpace()` outside `shmem_request_hook`. It reflects an extension coding issue rather than a user action.

## How to fix

There is no user-level fix. The extension must request shared memory from its `shmem_request_hook` while preloaded via `shared_preload_libraries`. If it appears with a packaged extension, report it to that extension.

## Example

*Illustrative* — requesting shared memory too late.

```text
FATAL:  cannot request additional shared memory outside shmem_request_hook
```

## Related

- [cannot request additional LWLocks outside shmem_request_hook](./cannot-request-additional-lwlocks-outside-shmem-request-hook.md)
- [cannot request shared memory at this time](./cannot-request-shared-memory-at-this-time.md)
