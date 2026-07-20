---
message: "block %u fell off the end of index \"%s\""
slug: block-fell-off-the-end-of-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:686"
reproduced: false
---

# `block %u fell off the end of index "%s"`

## What it means

While walking an index, `amcheck` followed a link to a block number beyond the index's current size. A valid index never points past its own end, so this indicates structural corruption. The placeholders are the block and index names.

## When it happens

It occurs during `bt_index_check` or `bt_index_parent_check` on a corrupted B-tree, or a case where the index and its size are inconsistent.

## How to fix

Treat the index as corrupt. Rebuild it with `REINDEX`, and investigate the underlying cause — storage faults, an operating-system or hardware problem, or a past crash. Run broader corruption checks if other indexes may be affected.

## Example

*Illustrative* — amcheck finding a dangling link.

```text
ERROR:  block 500 fell off the end of index "my_index"
```

## Related

- [block is not leftmost in index](./block-is-not-leftmost-in-index.md)
- [btree level not found in index](./btree-level-not-found-in-index.md)
