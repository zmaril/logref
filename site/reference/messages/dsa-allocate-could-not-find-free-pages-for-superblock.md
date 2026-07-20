---
message: "dsa_allocate could not find %zu free pages for superblock"
slug: dsa-allocate-could-not-find-free-pages-for-superblock
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/mmgr/dsa.c:1767"
reproduced: false
---

# `dsa_allocate could not find %zu free pages for superblock`

## What it means

An internal dynamic-shared-area allocator failure. `dsa_allocate` could not find enough free pages to carve out a new superblock. The placeholder is the page count. It indicates the shared-memory area is exhausted.

## When it happens

It fires when a DSA-backed feature needs to grow its pool and no contiguous free pages remain, typically under heavy concurrent memory pressure.

## How to fix

This is a resource-exhaustion condition. Reduce the concurrent memory demand of whatever uses the area (for example fewer parallel workers, or smaller per-operation limits). If it recurs without an obvious cause, capture the workload and server version for the PostgreSQL developers.

## Example

*Illustrative* — no free pages for a new superblock.

```text
FATAL:  dsa_allocate could not find 8 free pages for superblock
```

## Related

- [dsa_allocate could not find free pages](./dsa-allocate-could-not-find-free-pages.md)
- [dynamic shared memory control segment is not valid](./dynamic-shared-memory-control-segment-is-not-valid.md)
