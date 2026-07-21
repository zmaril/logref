---
message: "btree level %u not found in index \"%s\""
slug: btree-level-not-found-in-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/src/backend/access/nbtree/nbtsearch.c:2141"
reproduced: false
---

# `btree level %u not found in index "%s"`

## What it means

`amcheck` expected to reach a particular level of a B-tree while descending or walking it, but no page reported that level. A consistent B-tree has a continuous set of levels, and a missing one signals corruption. The placeholders are the level and index.

## When it happens

It occurs during `amcheck` verification of a damaged B-tree index.

## How to fix

Rebuild the index with `REINDEX` and investigate the corruption source — storage, hardware, or a prior crash. Verify related indexes for the same fault.

## Example

*Illustrative* — a missing B-tree level.

```text
ERROR:  btree level 2 not found in index "my_index"
```

## Related

- [block fell off the end of index](./block-fell-off-the-end-of-index.md)
- [block is not true root in index](./block-is-not-true-root-in-index.md)
