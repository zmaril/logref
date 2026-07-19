---
message: "cannot request additional LWLocks outside shmem_request_hook"
slug: cannot-request-additional-lwlocks-outside-shmem-request-hook
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/storage/lmgr/lwlock.c:626"
reproduced: false
---

# `cannot request additional LWLocks outside shmem_request_hook`

## What it means

An internal guard fired: code tried to reserve additional lightweight locks outside the `shmem_request_hook`. Extensions must request their LWLocks during that hook, before shared memory is sized, so a later request is refused.

## When it happens

It is reached when an extension calls `RequestNamedLWLockTranche()` outside `shmem_request_hook`. It reflects an extension coding issue rather than a user action.

## How to fix

There is no user-level fix. The extension must request LWLocks from its `shmem_request_hook` while preloaded via `shared_preload_libraries`. If it appears with a packaged extension, report it to that extension.

## Example

*Illustrative* — requesting LWLocks too late.

```text
FATAL:  cannot request additional LWLocks outside shmem_request_hook
```

## Related

- [cannot request additional shared memory outside shmem_request_hook](./cannot-request-additional-shared-memory-outside-shmem-request-hook.md)
- [cannot request shared memory at this time](./cannot-request-shared-memory-at-this-time.md)
