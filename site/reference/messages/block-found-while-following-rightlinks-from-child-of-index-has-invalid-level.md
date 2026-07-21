---
message: "block found while following rightlinks from child of index \"%s\" has invalid level"
slug: block-found-while-following-rightlinks-from-child-of-index-has-invalid-level
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:2235"
reproduced: false
---

# `block found while following rightlinks from child of index "%s" has invalid level`

## What it means

`amcheck` walked the sibling chain at one level of a B-tree and reached a page whose recorded tree level does not match. Every page on a level must report the same level, so a mismatch signals corruption. The placeholder is the index.

## When it happens

It occurs during an `amcheck` verification of a damaged B-tree index.

## How to fix

Rebuild the index with `REINDEX` and look for the root cause of corruption — hardware or storage errors, or a prior crash. Verify related indexes, since corruption often has a common source.

## Example

*Illustrative* — a level mismatch on the sibling chain.

```text
ERROR:  block found while following rightlinks from child of index "my_index" has invalid level
```

## Related

- [block fell off the end of index](./block-fell-off-the-end-of-index.md)
- [btree level not found in index](./btree-level-not-found-in-index.md)
