---
message: "circular link chain found in block %u of index \"%s\""
slug: circular-link-chain-found-in-block-of-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:790"
  - "postgres/contrib/amcheck/verify_nbtree.c:2244"
reproduced: false
---

# `circular link chain found in block %u of index "%s"`

## What it means

The `amcheck` extension detected a cycle in a B-tree index's sibling or link pointers while verifying it. The placeholders are the block number and the index name. A healthy B-tree has no circular link chains; a cycle indicates index corruption.

## When it happens

Running `bt_index_check()` or `bt_index_parent_check()` from `amcheck` against an index whose page links have become corrupt — from a storage fault, a crash bug, or bad hardware.

## How to fix

Rebuild the affected index with `REINDEX INDEX` to replace the corrupt structure. Then investigate the underlying cause — check storage and memory health, and review recent crashes — since corruption tends to recur if the root cause remains. Re-run `amcheck` afterward to confirm the rebuild is clean.

## Example

*Illustrative* — amcheck reporting a link cycle.

```text
ERROR:  circular link chain found in block 42 of index "t_idx"
```

## Related

- [compressed pglz data is corrupt](./compressed-pglz-data-is-corrupt.md)
- [corrupted item lengths total available space](./corrupted-item-lengths-total-available-space.md)
