---
message: "leaked parallel context"
slug: leaked-parallel-context
passthrough: false
api: [elog]
level: [WARNING]
call_sites:
  - "postgres/src/backend/access/transam/parallel.c:1273"
  - "postgres/src/backend/access/transam/parallel.c:1292"
reproduced: false
---

# `leaked parallel context`

## What it means

Internal warning. A parallel-query context was created and not properly torn down, so it was cleaned up as a leak at the end of the operation.

## When it happens

It fires when a code path that set up parallel workers exits without releasing the context — usually a missing cleanup in an error path or an extension.

## Is this a problem?

This is an internal resource-tracking warning. It is generally harmless once reported (the context is cleaned up), but recurring instances suggest a leak worth investigating; capture the query and any extensions and report it.

## Example

*Illustrative* — a leaked parallel context.

```text
WARNING:  leaked parallel context
```

## Related

- [leaked hash_seq_search scan for hash table %p](./leaked-hash-seq-search-scan-for-hash-table.md)
- [cannot remove relcache entry for "%s" because it has nonzero refcount](./cannot-remove-relcache-entry-for-because-it-has-nonzero-refcount.md)
