---
message: "failed to add new item to left page after split"
slug: failed-to-add-new-item-to-left-page-after-split
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtxlog.c:392"
  - "postgres/src/backend/access/nbtree/nbtxlog.c:408"
reproduced: false
---

# `failed to add new item to left page after split`

## What it means

Internal error. The b-tree access method could not place an item onto the left page after a b-tree split, even though its own bookkeeping said the item should fit. It is a consistency guard: index maintenance reached a state it treats as impossible.

## When it happens

It fires during b-tree index maintenance or WAL replay when the on-page free space did not match what the code computed. Ordinary queries do not raise it; it can accompany index or page corruption.

## How to fix

Treat it as possible index damage. Reindex the affected index. If it recurs, check storage health and capture the index name and a reproducible case for a bug report.

## Example

*Illustrative* — a b-tree item did not fit the left page after split.

```text
ERROR:  failed to add new item to left page after split
```

## Related

- [failed to add new item to the right sibling while splitting block of index](./failed-to-add-new-item-to-the-right-sibling-while-splitting-block-of-index.md)
- [failed to update partially dead item in block of index](./failed-to-update-partially-dead-item-in-block-of-index.md)
