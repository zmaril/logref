---
message: "could not initialize cache %u (%d)"
slug: could-not-initialize-cache
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/cache/syscache.c:136"
reproduced: false
---

# `could not initialize cache %u (%d)`

## What it means

The system-catalog cache subsystem could not set up one of its per-catalog caches at startup. The two numbers identify the cache and the underlying reason. These caches make repeated catalog lookups fast.

## When it happens

It fires during backend initialization while building the catalog caches, when one cannot be created — an internal, early-startup failure rather than anything a query triggers.

## How to fix

This is an internal guard reached only during startup. It usually points at a build mismatch or memory corruption. Make sure all binaries and preloaded libraries are from the same build; if it recurs on a clean install, capture the log and report it.

## Example

*Illustrative* — a catalog cache failed to initialize.

```text
ERROR:  could not initialize cache 11 (0)
```

## Related

- [could not initialize local buffer hash table](./could-not-initialize-local-buffer-hash-table.md)
- [could not find shmemindex entry for data structure](./could-not-find-shmemindex-entry-for-data-structure.md)
