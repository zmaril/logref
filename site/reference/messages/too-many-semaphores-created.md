---
message: "too many semaphores created"
slug: too-many-semaphores-created
passthrough: false
api: [elog]
level: [PANIC]
call_sites:
  - "postgres/src/backend/port/posix_sema.c:264"
  - "postgres/src/backend/port/sysv_sema.c:397"
  - "postgres/src/backend/port/sysv_sema.c:404"
  - "postgres/src/backend/port/win32_sema.c:87"
reproduced: false
---

# `too many semaphores created`

## What it means

Internal error at the OS-semaphore layer. Postgres asked the kernel for another semaphore beyond the number it had provisioned for the cluster. The server sizes its semaphore needs at startup from settings like `max_connections`; overrunning that count is a `can't happen` guard in the semaphore allocator.

## When it happens

It should not occur in a correctly configured cluster. Reaching it indicates an internal miscount of semaphore demand rather than the usual OS-side `could not create semaphores` shortage (which is a separate, kernel-limit error).

## How to fix

Treat it as an internal bug. Capture the cluster's connection/background-worker settings and the circumstances, and report it. This is distinct from the OS `SEMMNS`/`SEMMNI` exhaustion errors, which are fixed by raising kernel semaphore limits — those report a different message.

## Example

*Illustrative* — emitted internally by the semaphore allocator.

```text
PANIC:  too many semaphores created
```

## Related

- [out of binary heap slots](./out-of-binary-heap-slots.md)
- [failed to re-find shared lock object](./failed-to-re-find-shared-lock-object.md)
