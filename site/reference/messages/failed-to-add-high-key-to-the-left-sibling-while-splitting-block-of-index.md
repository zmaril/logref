---
message: "failed to add high key to the left sibling while splitting block %u of index \"%s\""
slug: failed-to-add-high-key-to-the-left-sibling-while-splitting-block-of-index
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtinsert.c:1726"
reproduced: false
---

# `failed to add high key to the left sibling while splitting block %u of index "%s"`

## What it means

An internal guard during a live B-tree page split. Splitting a page, the code could not add the high key to the left sibling page. The placeholders are the block number and index name. The high key bounds the left page's key range.

## When it happens

It fires during normal B-tree insertion when a page split cannot complete because the high key does not fit on the left sibling. It can reflect an unexpected internal condition or, occasionally, unusually large index keys.

## How to fix

This is an internal invariant. Check whether the indexed columns hold very large values near the B-tree tuple-size limit, which can make splits fail; shortening the indexed expression or using a hash of long values can help. Verify storage health, and rebuild the index with `REINDEX`. Report it with the index definition if the keys are ordinary.

## Example

*Illustrative* — the message as logged.

```
ERROR:  failed to add high key to the left sibling while splitting block 42 of index "orders_idx"
```

## Related

- [failed to add high key to the right sibling while splitting block of index](./failed-to-add-high-key-to-the-right-sibling-while-splitting-block-of-index.md)
- [failed to add high key to left page after split](./failed-to-add-high-key-to-left-page-after-split.md)
