---
message: "downlink or sibling link points to deleted block in index \"%s\""
slug: downlink-or-sibling-link-points-to-deleted-block-in-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:678"
reproduced: false
---

# `downlink or sibling link points to deleted block in index "%s"`

## What it means

`amcheck` found a B-tree downlink or sibling pointer that references a block already marked deleted. The placeholder is the index name. Live pointers must not target deleted blocks, so this reports index corruption.

## When it happens

It fires while `amcheck` verifies a B-tree's structure and finds a link into a deleted page, indicating physical damage or an interrupted operation.

## How to fix

Rebuild the index with `REINDEX INDEX` (or `REINDEX ... CONCURRENTLY`). Investigate the underlying cause — storage faults or an unclean crash — and check other indexes on the same volume.

## Example

*Illustrative* — amcheck found a link to a deleted block.

```text
ERROR:  downlink or sibling link points to deleted block in index "orders_pkey"
```

## Related

- [downlink to deleted page found in index](./downlink-to-deleted-page-found-in-index.md)
- [downlink to deleted leaf page found in index](./downlink-to-deleted-leaf-page-found-in-index.md)
