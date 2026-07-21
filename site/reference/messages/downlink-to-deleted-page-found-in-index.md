---
message: "downlink to deleted page found in index \"%s\""
slug: downlink-to-deleted-page-found-in-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:2492"
reproduced: false
---

# `downlink to deleted page found in index "%s"`

## What it means

`amcheck` found a B-tree downlink that points to a page marked deleted. The placeholder is the index name. Downlinks must reference live pages, so this reports index corruption.

## When it happens

It fires while `amcheck` verifies a B-tree and finds a parent downlink referencing a deleted page, indicating physical damage or an interrupted operation.

## How to fix

Rebuild the index with `REINDEX INDEX` (or `REINDEX ... CONCURRENTLY`). Investigate the cause — failing storage or an unclean crash — and check other indexes on the same storage.

## Example

*Illustrative* — amcheck found a downlink to a deleted page.

```text
ERROR:  downlink to deleted page found in index "orders_pkey"
```

## Related

- [downlink to deleted leaf page found in index](./downlink-to-deleted-leaf-page-found-in-index.md)
- [downlink or sibling link points to deleted block in index](./downlink-or-sibling-link-points-to-deleted-block-in-index.md)
