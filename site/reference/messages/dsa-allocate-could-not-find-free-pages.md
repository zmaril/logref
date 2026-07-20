---
message: "dsa_allocate could not find %zu free pages"
slug: dsa-allocate-could-not-find-free-pages
passthrough: false
api: [elog]
level: [FATAL]
call_sites:
  - "postgres/src/backend/utils/mmgr/dsa.c:758"
reproduced: false
---

# `dsa_allocate could not find %zu free pages`

## What it means

An internal dynamic-shared-area allocator failure. `dsa_allocate` could not obtain the requested number of free pages of shared memory. The placeholder is the page count. It generally means a shared-memory region is exhausted.

## When it happens

It fires when a feature backed by a dynamic shared area (parallel query, some extensions) runs out of allocatable pages in its DSA, often under heavy concurrent use.

## How to fix

This is a resource-exhaustion condition, not a query bug. If it correlates with parallel query or an extension, reduce concurrency or the per-operation memory demand. Raising memory-related settings for the feature involved, or lowering parallel workers, can relieve it. Capture the workload for the PostgreSQL developers if it recurs unexpectedly.

## Example

*Illustrative* — the allocator ran out of pages.

```text
FATAL:  dsa_allocate could not find 3 free pages
```

## Related

- [dsa_allocate could not find free pages for superblock](./dsa-allocate-could-not-find-free-pages-for-superblock.md)
- [dynamic shared memory control segment is not valid](./dynamic-shared-memory-control-segment-is-not-valid.md)
