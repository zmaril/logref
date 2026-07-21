---
message: "block %u is not true root in index \"%s\""
slug: block-is-not-true-root-in-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:715"
reproduced: false
---

# `block %u is not true root in index "%s"`

## What it means

`amcheck` followed the index's recorded root pointer to a page that does not identify itself as the true root. The root page must mark itself as such, and this mismatch signals corruption or a stale meta page. The placeholders are the block and index.

## When it happens

It occurs during `amcheck` verification of a B-tree whose meta page or root linkage is inconsistent.

## How to fix

Rebuild the index with `REINDEX`, which rewrites the meta page and root. Investigate the underlying cause of corruption and verify related indexes.

## Example

*Illustrative* — a root pointer to a non-root page.

```text
ERROR:  block 3 is not true root in index "my_index"
```

## Related

- [block is not leftmost in index](./block-is-not-leftmost-in-index.md)
- [btree level not found in index](./btree-level-not-found-in-index.md)
