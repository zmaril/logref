---
message: "can't find left sibling high key in index \"%s\""
slug: can-t-find-left-sibling-high-key-in-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:2340"
reproduced: false
---

# `can't find left sibling high key in index "%s"`

## What it means

`amcheck` walked a B-tree and could not locate the high key on a page's left sibling that its checks require. A consistent B-tree always has this key, so its absence indicates structural corruption. The placeholder is the index.

## When it happens

It occurs during `amcheck` verification of a damaged B-tree index.

## How to fix

Rebuild the index with `REINDEX` and investigate the cause of corruption — storage faults, hardware, or a prior crash. Check related indexes for similar damage.

## Example

*Illustrative* — a missing sibling high key.

```text
ERROR:  can't find left sibling high key in index "my_index"
```

## Related

- [can't traverse from downlink to downlink of index](./can-t-traverse-from-downlink-to-downlink-of-index.md)
- [btree level not found in index](./btree-level-not-found-in-index.md)
