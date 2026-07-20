---
message: "cross page item order invariant violated for index \"%s\""
slug: cross-page-item-order-invariant-violated-for-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:1747"
reproduced: false
---

# `cross page item order invariant violated for index "%s"`

## What it means

`amcheck` found that items in a B-tree index are not in the expected order across a page boundary. The placeholder is the index name. B-tree pages must hold keys in sorted order, and this check spans adjacent pages; the invariant failed. The server reports it as index corruption.

## When it happens

It fires while `bt_index_check` or `bt_index_parent_check` from the `amcheck` extension verifies a B-tree and finds keys out of order between pages, which indicates a physically damaged index.

## How to fix

The index is corrupt. Rebuild it with `REINDEX INDEX` (or `REINDEX ... CONCURRENTLY`). Investigate the underlying cause — failing storage, or a past crash without proper recovery — since corruption often recurs if the hardware is at fault. Check other indexes on the same storage as well.

## Example

*Illustrative* — amcheck found an ordering violation.

```text
ERROR:  cross page item order invariant violated for index "orders_pkey"
```

## Related

- [could not split GIN page; all old items didn't fit](./could-not-split-gin-page-all-old-items-didn-t-fit.md)
- [dead heap-only tuple is not linked to from any HOT chain](./dead-heap-only-tuple-is-not-linked-to-from-any-hot-chain.md)
