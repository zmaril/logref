---
message: "down-link lower bound invariant violated for index \"%s\""
slug: down-link-lower-bound-invariant-violated-for-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:2533"
reproduced: false
---

# `down-link lower bound invariant violated for index "%s"`

## What it means

`amcheck` found that a B-tree downlink's lower-bound key does not satisfy the ordering invariant with the child page it points to. The placeholder is the index name. It reports a physically inconsistent index.

## When it happens

It fires while `bt_index_parent_check` from the `amcheck` extension verifies parent/child key relationships and finds a downlink key out of bounds, indicating index corruption.

## How to fix

Rebuild the index with `REINDEX INDEX` (or `REINDEX ... CONCURRENTLY`). Investigate the cause — failing storage, or a crash without proper recovery — since corruption recurs on bad hardware. Check other indexes on the same storage.

## Example

*Illustrative* — amcheck found a downlink bound violation.

```text
ERROR:  down-link lower bound invariant violated for index "orders_pkey"
```

## Related

- [downlink points to block in index whose level is not one level down](./downlink-points-to-block-in-index-whose-level-is-not-one-level-down.md)
- [downlink or sibling link points to deleted block in index](./downlink-or-sibling-link-points-to-deleted-block-in-index.md)
