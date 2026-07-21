---
message: "deduplication failed to add heap tid to pending posting list"
slug: deduplication-failed-to-add-heap-tid-to-pending-posting-list
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtxlog.c:515"
reproduced: false
---

# `deduplication failed to add heap tid to pending posting list`

## What it means

An internal consistency guard in the B-tree deduplication code. While merging duplicate index entries into a posting list, the code could not append a heap TID it expected to fit. This is a "can't happen" check.

## When it happens

It fires during B-tree index insertion or WAL replay of a deduplication record, when the in-progress posting list is in an unexpected state. It points at a logic error or at index corruption rather than anything a query did wrong.

## How to fix

This is not a user-facing condition. If it recurs, treat the index as suspect: rebuild it with `REINDEX` and check the underlying storage. Capture the full log context and the server version, since a reproducible case is worth reporting to the PostgreSQL developers.

## Example

*Illustrative* — the guard as it appears in the log.

```text
ERROR:  deduplication failed to add heap tid to pending posting list
```

## Related

- [down-link lower bound invariant violated for index](./down-link-lower-bound-invariant-violated-for-index.md)
- [deleted page block in index is half-dead](./deleted-page-block-in-index-is-half-dead.md)
