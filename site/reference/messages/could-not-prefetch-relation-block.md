---
message: "could not prefetch relation %u/%u/%u block %u"
slug: could-not-prefetch-relation-block
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/transam/xlogprefetcher.c:796"
reproduced: false
---

# `could not prefetch relation %u/%u/%u block %u`

## What it means

During WAL replay the recovery prefetcher tried to hint the operating system to read a relation block ahead of time and the request failed. The numbers identify the relation and block. Prefetching is an optimization, so this is unexpected but not fatal to correctness.

## When it happens

It fires during recovery when a prefetch request for a block cannot be issued — usually a missing relation segment the prefetcher looked ahead into, or an I/O problem on the data directory.

## How to fix

This is an internal guard around a recovery optimization. It often points at storage trouble the main replay path will also hit. Check the data directory's storage health; if prefetch problems persist, `recovery_prefetch` can be turned off to sidestep the optimization while you investigate.

## Example

*Illustrative* — a recovery prefetch that failed.

```text
ERROR:  could not prefetch relation 1663/16384/16400 block 42
```

## Related

- [could not open file (target block)](./could-not-open-file-target-block.md)
- [could not read block in file](./could-not-read-block-in-file.md)
