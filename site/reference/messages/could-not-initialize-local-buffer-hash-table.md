---
message: "could not initialize local buffer hash table"
slug: could-not-initialize-local-buffer-hash-table
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/storage/buffer/localbuf.c:815"
reproduced: false
---

# `could not initialize local buffer hash table`

## What it means

A backend tried to create the hash table that tracks its local buffers — the private buffer pool used for temporary tables — and could not. This table maps temporary-table pages to their local buffers.

## When it happens

It fires while a backend sets up local buffering for temporary tables, when the hash table cannot be created — usually memory pressure or an internal inconsistency at that point.

## How to fix

This is an internal guard. It generally points at memory exhaustion in the backend. Check the host and per-process memory limits, reduce concurrent memory demand, and retry. If it recurs with ample memory, capture the log and report it.

## Example

*Illustrative* — the local buffer hash table could not be created.

```text
ERROR:  could not initialize local buffer hash table
```

## Related

- [could not initialize cache](./could-not-initialize-cache.md)
- [could not find shmemindex entry for data structure](./could-not-find-shmemindex-entry-for-data-structure.md)
