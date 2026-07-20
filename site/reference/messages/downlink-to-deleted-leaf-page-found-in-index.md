---
message: "downlink to deleted leaf page found in index \"%s\""
slug: downlink-to-deleted-leaf-page-found-in-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:2691"
reproduced: false
---

# `downlink to deleted leaf page found in index "%s"`

## What it means

`amcheck` found a B-tree downlink that points to a leaf page marked deleted. The placeholder is the index name. A downlink must never target a deleted leaf, so this reports index corruption.

## When it happens

It fires while `amcheck` verifies a B-tree and finds a parent downlink referencing a deleted leaf page, indicating physical damage or an interrupted page deletion.

## How to fix

Rebuild the index with `REINDEX INDEX` (or `REINDEX ... CONCURRENTLY`). Investigate storage health and recent crash recovery, and check other indexes on the same volume, since corruption often recurs.

## Example

*Illustrative* — amcheck found a downlink to a deleted leaf.

```text
ERROR:  downlink to deleted leaf page found in index "orders_pkey"
```

## Related

- [downlink to deleted page found in index](./downlink-to-deleted-page-found-in-index.md)
- [deleted page block in index is half-dead](./deleted-page-block-in-index-is-half-dead.md)
