---
message: "leaked hash_seq_search scan for hash table %p"
slug: leaked-hash-seq-search-scan-for-hash-table
passthrough: false
api: [elog]
level: [WARNING]
call_sites:
  - "postgres/src/backend/utils/hash/dynahash.c:1881"
  - "postgres/src/backend/utils/hash/dynahash.c:1904"
reproduced: false
---

# `leaked hash_seq_search scan for hash table %p`

## What it means

Internal warning. A sequential scan over a hash table was started and not properly finished, so its scan state was cleaned up as a leak at the end of the operation.

## When it happens

It fires when code that iterates a dynamic hash table exits without terminating the scan — usually a missing cleanup path in a code branch or an extension.

## Is this a problem?

This is an internal resource-tracking warning. It is generally harmless once reported (the scan is cleaned up), but recurring instances suggest a leak worth investigating; capture the workload and any extensions and report it.

## Example

*Illustrative* — a leaked hash-scan.

```text
WARNING:  leaked hash_seq_search scan for hash table 0x55a1b2c3
```

## Related

- [leaked parallel context](./leaked-parallel-context.md)
- [cannot remove relcache entry for "%s" because it has nonzero refcount](./cannot-remove-relcache-entry-for-because-it-has-nonzero-refcount.md)
