---
message: "failed to add high key to the right sibling while splitting block %u of index \"%s\""
slug: failed-to-add-high-key-to-the-right-sibling-while-splitting-block-of-index
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtinsert.c:1797"
reproduced: false
---

# `failed to add high key to the right sibling while splitting block %u of index "%s"`

## What it means

An internal guard during a live B-tree page split. Splitting a page, the code could not add the high key to the right sibling page. The placeholders are the block number and index name.

## When it happens

It fires during normal B-tree insertion when a page split cannot complete because the high key does not fit on the right sibling. It usually indicates an unexpected internal condition, sometimes tied to oversize index keys.

## How to fix

This is an internal invariant. Look for very large indexed values near the per-tuple size limit and shorten them (for example index a hash or prefix of long text). Confirm storage integrity and rebuild the index with `REINDEX`. Capture the index definition and report it if the keys are ordinary.

## Example

*Illustrative* — the message as logged.

```
ERROR:  failed to add high key to the right sibling while splitting block 42 of index "orders_idx"
```

## Related

- [failed to add high key to the left sibling while splitting block of index](./failed-to-add-high-key-to-the-left-sibling-while-splitting-block-of-index.md)
- [failed to add item to the index page](./failed-to-add-item-to-the-index-page.md)
