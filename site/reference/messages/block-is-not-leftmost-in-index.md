---
message: "block %u is not leftmost in index \"%s\""
slug: block-is-not-leftmost-in-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:709"
reproduced: false
---

# `block %u is not leftmost in index "%s"`

## What it means

`amcheck` expected a particular page to be the leftmost page on its B-tree level but found it is not. The leftmost page has no left sibling, and this structural expectation was violated, indicating corruption. The placeholders are the block and index.

## When it happens

It occurs during `amcheck` verification of a damaged B-tree.

## How to fix

Rebuild the index with `REINDEX` and investigate the source of corruption — storage, hardware, or a prior crash. Check related indexes for the same problem.

## Example

*Illustrative* — a page wrongly treated as leftmost.

```text
ERROR:  block 12 is not leftmost in index "my_index"
```

## Related

- [block is not true root in index](./block-is-not-true-root-in-index.md)
- [block fell off the end of index](./block-fell-off-the-end-of-index.md)
