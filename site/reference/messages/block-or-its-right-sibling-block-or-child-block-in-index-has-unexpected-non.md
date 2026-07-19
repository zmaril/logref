---
message: "block %u or its right sibling block or child block in index \"%s\" has unexpected non-pivot tuple"
slug: block-or-its-right-sibling-block-or-child-block-in-index-has-unexpected-non
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:3551"
reproduced: false
---

# `block %u or its right sibling block or child block in index "%s" has unexpected non-pivot tuple`

## What it means

`amcheck` found a non-pivot tuple on a page where the B-tree structure does not permit one. Pivot and non-pivot tuples belong on specific page kinds, and this placement is invalid, signaling corruption. The placeholders are the block and index.

## When it happens

It occurs during `amcheck` verification of a damaged B-tree index.

## How to fix

Rebuild the index with `REINDEX` and find the root cause of corruption — hardware, storage, or a prior crash. Verify related indexes for the same fault.

## Example

*Illustrative* — a misplaced non-pivot tuple.

```text
ERROR:  block 8 or its right sibling block or child block in index "my_index" has unexpected non-pivot tuple
```

## Related

- [block or its right sibling block or child block in index contains non-pivot](./block-or-its-right-sibling-block-or-child-block-in-index-contains-non-pivot.md)
- [block or its right sibling block or child block in index has unexpected pivot tuple](./block-or-its-right-sibling-block-or-child-block-in-index-has-unexpected-pivot.md)
