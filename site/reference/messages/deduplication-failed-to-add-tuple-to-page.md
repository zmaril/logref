---
message: "deduplication failed to add tuple to page"
slug: deduplication-failed-to-add-tuple-to-page
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtdedup.c:575"
  - "postgres/src/backend/access/nbtree/nbtdedup.c:594"
reproduced: false
---

# `deduplication failed to add tuple to page`

## What it means

Internal error during b-tree deduplication. A deduplicated (posting-list) tuple could not be added to the rebuilt leaf page. It is a consistency guard in the nbtree deduplication code.

## When it happens

It fires while nbtree deduplication rewrites a leaf page during insertion or WAL replay and the tuple did not fit as expected. Ordinary queries do not raise it.

## How to fix

Treat it like possible index damage: reindex the affected index. If it persists, check storage health and report a reproducible case with the index name.

## Example

*Illustrative* — a deduplicated tuple did not fit.

```text
ERROR:  deduplication failed to add tuple to page
```

## Related

- [deduplication failed to add highkey](./deduplication-failed-to-add-highkey.md)
- [failed to add new item to left page after split](./failed-to-add-new-item-to-left-page-after-split.md)
