---
message: "could not find tuple using search from root page in index \"%s\""
slug: could-not-find-tuple-using-search-from-root-page-in-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:1395"
reproduced: false
---

# `could not find tuple using search from root page in index "%s"`

## What it means

`amcheck` walked a B-tree index from its root to locate a tuple it had already seen on a leaf page and could not reach it. A consistent B-tree must be navigable from the root to every live entry, and this one is not.

## When it happens

It is reported by the `amcheck` extension (`bt_index_check` / `bt_index_parent_check`) when the index structure is damaged — a broken downlink, a lost split, or on-disk corruption.

## How to fix

Treat the index as corrupt. Rebuild it with `REINDEX INDEX`, and investigate the underlying cause — failing storage, a hardware fault, or an operating-system change to collation ordering. Run `amcheck` again after the rebuild to confirm the structure is sound.

## Example

*Illustrative* — amcheck cannot reach a known tuple from the root.

```text
ERROR:  could not find tuple using search from root page in index "orders_pkey"
```

## Related

- [could not find left sibling of block in index](./could-not-find-left-sibling-of-block-in-index.md)
- [could not find a feasible split point for index](./could-not-find-a-feasible-split-point-for-index.md)
