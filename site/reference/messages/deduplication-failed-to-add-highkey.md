---
message: "deduplication failed to add highkey"
slug: deduplication-failed-to-add-highkey
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtdedup.c:131"
  - "postgres/src/backend/access/nbtree/nbtxlog.c:497"
reproduced: false
---

# `deduplication failed to add highkey`

## What it means

Internal error during b-tree deduplication. While rewriting a leaf page into deduplicated form, the code could not place the page's high key. It is a consistency guard in the nbtree deduplication path.

## When it happens

It fires during b-tree index maintenance (insertion or WAL replay) that runs deduplication, when the rebuilt page unexpectedly lacked room for the high key. Ordinary queries do not raise it.

## How to fix

This is a can't-happen guard that can accompany index corruption. Reindex the affected index. If it recurs, check storage health and report a reproducible case with the index name.

## Example

*Illustrative* — deduplication could not place the high key.

```text
ERROR:  deduplication failed to add highkey
```

## Related

- [deduplication failed to add tuple to page](./deduplication-failed-to-add-tuple-to-page.md)
- [failed to add item to index page](./failed-to-add-item-to-index-page.md)
