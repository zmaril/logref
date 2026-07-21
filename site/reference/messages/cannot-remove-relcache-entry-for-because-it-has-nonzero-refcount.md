---
message: "cannot remove relcache entry for \"%s\" because it has nonzero refcount"
slug: cannot-remove-relcache-entry-for-because-it-has-nonzero-refcount
passthrough: false
api: [elog]
level: [WARNING]
call_sites:
  - "postgres/src/backend/utils/cache/relcache.c:3366"
  - "postgres/src/backend/utils/cache/relcache.c:3476"
reproduced: false
---

# `cannot remove relcache entry for "%s" because it has nonzero refcount`

## What it means

Internal warning. The relation-cache tried to drop a cached entry for a relation, but the entry is still referenced (its reference count is not zero), so it was kept.

## When it happens

It fires when a relcache invalidation coincides with the relation still being in use — often a sign of a reference leak in an extension or in a code path, rather than ordinary activity.

## Is this a problem?

This is an internal consistency warning. It is usually harmless in isolation, but repeated occurrences suggest a relcache reference leak; capture the workload (especially any extensions) and report it.

## Example

*Illustrative* — a still-referenced relcache entry.

```text
WARNING:  cannot remove relcache entry for "orders" because it has nonzero refcount
```

## Related

- [leaked hash_seq_search scan for hash table %p](./leaked-hash-seq-search-scan-for-hash-table.md)
- [leaked parallel context](./leaked-parallel-context.md)
