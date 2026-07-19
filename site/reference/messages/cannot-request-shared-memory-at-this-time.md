---
message: "cannot request shared memory at this time"
slug: cannot-request-shared-memory-at-this-time
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/ipc/shmem.c:882"
reproduced: false
---

# `cannot request shared memory at this time`

## What it means

An internal guard fired: shared memory was requested at a point in startup when it can no longer be granted. The shared-memory area is fixed once initialization completes, so a request after that point is refused.

## When it happens

It is reached when an extension or code path asks for shared memory outside the allowed startup window. It reflects a coding issue rather than a user action.

## How to fix

There is no user-level fix. Shared-memory requests must happen during the designated startup hook. If it appears with a packaged extension, report it to that extension.

## Example

*Illustrative* — a shared-memory request too late in startup.

```text
ERROR:  cannot request shared memory at this time
```

## Related

- [cannot request additional shared memory outside shmem_request_hook](./cannot-request-additional-shared-memory-outside-shmem-request-hook.md)
- [cannot register background worker after shmem init](./cannot-register-background-worker-after-shmem-init.md)
