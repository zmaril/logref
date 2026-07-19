---
message: "deleted page block %u in index \"%s\" is half-dead"
slug: deleted-page-block-in-index-is-half-dead
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_nbtree.c:3445"
reproduced: false
---

# `deleted page block %u in index "%s" is half-dead`

## What it means

`amcheck` found a B-tree index page in the "half-dead" state — an intermediate state used during page deletion that should never persist after the operation completes. The placeholders are the block number and index name. It reports a physically inconsistent index.

## When it happens

It fires while `bt_index_check`/`bt_index_parent_check` from the `amcheck` extension verifies a B-tree and finds a page left half-dead, which indicates an interrupted page deletion or corruption.

## How to fix

Rebuild the index with `REINDEX INDEX` (or `REINDEX ... CONCURRENTLY`). Investigate the cause — a crash without proper recovery, or failing storage — since corruption often recurs on bad hardware. Verify other indexes on the same storage too.

## Example

*Illustrative* — amcheck found a half-dead page.

```text
ERROR:  deleted page block 42 in index "orders_pkey" is half-dead
```

## Related

- [down-link lower bound invariant violated for index](./down-link-lower-bound-invariant-violated-for-index.md)
- [downlink to deleted page found in index](./downlink-to-deleted-page-found-in-index.md)
