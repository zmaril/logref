---
message: "block %u or its right sibling block or child block in index \"%s\" contains non-pivot tuple that lacks a heap TID"
slug: block-or-its-right-sibling-block-or-child-block-in-index-contains-non-pivot
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:3559"
reproduced: false
---

# `block %u or its right sibling block or child block in index "%s" contains non-pivot tuple that lacks a heap TID`

## What it means

`amcheck` found a page that should hold only pivot tuples but contains a non-pivot tuple lacking a heap TID, which points at internal structural corruption of a B-tree. The placeholders are the block and index.

## When it happens

It occurs during a thorough `amcheck` verification (`bt_index_parent_check` with heap-TID checking) of a damaged B-tree.

## How to fix

Rebuild the index with `REINDEX` and investigate the cause of corruption — storage, hardware, or a crash. Check whether related indexes are affected and consider broader consistency checks.

## Example

*Illustrative* — a pivot page holding a bad tuple.

```text
ERROR:  block 8 or its right sibling block or child block in index "my_index" contains non-pivot tuple that lacks a heap TID
```

## Related

- [block or its right sibling block or child block in index has unexpected non-pivot tuple](./block-or-its-right-sibling-block-or-child-block-in-index-has-unexpected-non.md)
- [block or its right sibling block or child block in index has unexpected pivot tuple](./block-or-its-right-sibling-block-or-child-block-in-index-has-unexpected-pivot.md)
