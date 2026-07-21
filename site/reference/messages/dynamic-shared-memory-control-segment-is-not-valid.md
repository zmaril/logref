---
message: "dynamic shared memory control segment is not valid"
slug: dynamic-shared-memory-control-segment-is-not-valid
passthrough: false
api: [ereport]
level: [FATAL]
sqlstate:
  - symbol: ERRCODE_INTERNAL_ERROR
    code: "XX000"
call_sites:
  - "postgres/src/backend/storage/ipc/dsm.c:452"
reproduced: false
---

# `dynamic shared memory control segment is not valid`

## What it means

At startup or attach, PostgreSQL found the dynamic-shared-memory control segment invalid. The control segment tracks all DSM segments; an invalid one means shared-memory state could not be recovered or verified.

## When it happens

It fires during server startup or when a backend attaches to shared memory, typically after a crash when leftover shared-memory state does not match, or when another program has taken the expected shared-memory key.

## How to fix

Usually a restart clears leftover DSM state. If it persists, check for stale shared-memory segments (`ipcs`) from a previous crashed instance and remove them, and make sure no other process is using the same `dynamic_shared_memory_type` resources. Ensure a clean shutdown before restart.

## Example

*Illustrative* — an invalid DSM control segment at startup.

```text
FATAL:  dynamic shared memory control segment is not valid
```

## Related

- [dsa_allocate could not find free pages](./dsa-allocate-could-not-find-free-pages.md)
- [dsa_area could not attach to segment](./dsa-area-could-not-attach-to-segment.md)
