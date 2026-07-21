---
message: "cannot register background worker \"%s\" after shmem init"
slug: cannot-register-background-worker-after-shmem-init
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/postmaster/bgworker.c:998"
reproduced: false
---

# `cannot register background worker "%s" after shmem init`

## What it means

An internal guard fired: code tried to register a background worker after shared-memory initialization was complete. Static background workers must be registered during postmaster startup, before shared memory is set up. The placeholder is the worker name.

## When it happens

It is reached when an extension calls `RegisterBackgroundWorker()` too late — outside the `_PG_init` path that runs at postmaster start. It reflects an extension coding issue rather than a user action.

## How to fix

There is no user-level fix. The extension must register static background workers from `_PG_init` while loaded via `shared_preload_libraries`, or use dynamic workers instead. If it appears with a packaged extension, report it to that extension.

## Example

*Illustrative* — registering a worker too late.

```text
ERROR:  cannot register background worker "my_worker" after shmem init
```

## Related

- [cannot request additional shared memory outside shmem_request_hook](./cannot-request-additional-shared-memory-outside-shmem-request-hook.md)
- [cannot read pg_class without having selected a database](./cannot-read-pg-class-without-having-selected-a-database.md)
