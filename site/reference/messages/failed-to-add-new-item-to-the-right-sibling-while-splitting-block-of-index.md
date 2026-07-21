---
message: "failed to add new item to the right sibling while splitting block %u of index \"%s\""
slug: failed-to-add-new-item-to-the-right-sibling-while-splitting-block-of-index
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtinsert.c:1856"
  - "postgres/src/backend/access/nbtree/nbtinsert.c:1900"
reproduced: false
---

# `failed to add new item to the right sibling while splitting block %u of index "%s"`

## What it means

Internal error during a b-tree page split. The new item could not be placed on the right sibling page while splitting a block. The `%u` is the block and the `%s` is the index. It is a consistency guard in nbtree insertion.

## When it happens

It fires during b-tree insertion that splits a page, when the right-hand page lacked the expected space. Ordinary queries do not raise it; it can accompany index corruption.

## How to fix

Reindex the affected index. If it recurs, check storage health and capture the block number, index name, and a reproducible case for a bug report.

## Example

*Illustrative* — a split could not place the item on the right sibling.

```text
ERROR:  failed to add new item to the right sibling while splitting block 5 of index "my_idx"
```

## Related

- [failed to add new item to left page after split](./failed-to-add-new-item-to-left-page-after-split.md)
- [failed to re-find tuple within index](./failed-to-re-find-tuple-within-index.md)
