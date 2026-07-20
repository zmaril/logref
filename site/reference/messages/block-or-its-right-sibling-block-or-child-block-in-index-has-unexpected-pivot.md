---
message: "block %u or its right sibling block or child block in index \"%s\" has unexpected pivot tuple"
slug: block-or-its-right-sibling-block-or-child-block-in-index-has-unexpected-pivot
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:3544"
reproduced: false
---

# `block %u or its right sibling block or child block in index "%s" has unexpected pivot tuple`

## What it means

`amcheck` found a pivot tuple on a page where the B-tree structure does not allow one. Pivot tuples separate keys on internal levels, and finding one out of place indicates corruption. The placeholders are the block and index.

## When it happens

It occurs during `amcheck` verification of a corrupted B-tree index.

## How to fix

Rebuild the index with `REINDEX` and investigate the corruption source — storage, hardware, or a crash. Check related indexes for similar damage.

## Example

*Illustrative* — a misplaced pivot tuple.

```text
ERROR:  block 8 or its right sibling block or child block in index "my_index" has unexpected pivot tuple
```

## Related

- [block or its right sibling block or child block in index has unexpected non-pivot tuple](./block-or-its-right-sibling-block-or-child-block-in-index-has-unexpected-non.md)
- [block or its right sibling block or child block in index contains non-pivot](./block-or-its-right-sibling-block-or-child-block-in-index-contains-non-pivot.md)
