---
message: "downlink points to block in index \"%s\" whose level is not one level down"
slug: downlink-points-to-block-in-index-whose-level-is-not-one-level-down
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:2653"
reproduced: false
---

# `downlink points to block in index "%s" whose level is not one level down`

## What it means

`amcheck` found a B-tree downlink pointing to a page that is not exactly one level below its parent. The placeholder is the index name. B-tree levels must decrease by exactly one across a downlink, so this reports corruption.

## When it happens

It fires while `bt_index_parent_check` from the `amcheck` extension verifies the tree's level structure and finds a downlink to the wrong level.

## How to fix

Rebuild the index with `REINDEX INDEX` (or `REINDEX ... CONCURRENTLY`). Investigate the cause — failing hardware or an unclean crash — since such corruption tends to recur, and check other indexes on the same storage.

## Example

*Illustrative* — amcheck found a level mismatch.

```text
ERROR:  downlink points to block in index "orders_pkey" whose level is not one level down
```

## Related

- [down-link lower bound invariant violated for index](./down-link-lower-bound-invariant-violated-for-index.md)
- [downlink or sibling link points to deleted block in index](./downlink-or-sibling-link-points-to-deleted-block-in-index.md)
