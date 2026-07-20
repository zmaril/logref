---
message: "index \"%s\": internal pages traversal encountered leaf page unexpectedly on block %u"
slug: index-internal-pages-traversal-encountered-leaf-page-unexpectedly-on-block
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_gin.c:196"
  - "postgres/contrib/amcheck/verify_gin.c:491"
reproduced: false
---

# `index "%s": internal pages traversal encountered leaf page unexpectedly on block %u`

## What it means

While descending a btree index, `amcheck` (or an internal traversal) followed a downlink expected to reach an internal page but landed on a leaf page instead. The tree structure is inconsistent, indicating index corruption.

## When it happens

It is reported by `bt_index_parent_check` and related verification, or during traversal, when the level bookkeeping in the index does not match the actual page contents. It signals a damaged btree, not a data problem.

## How to fix

Rebuild the index with `REINDEX INDEX`. If verification still fails after a rebuild, look for storage-level corruption: review the server log for I/O errors and check the underlying disk. Record the index name and block number reported.

## Example

*Illustrative* — a downlink reaching a leaf where an internal page was expected.

```text
ERROR:  index "my_idx": internal pages traversal encountered leaf page unexpectedly on block 42
```

## Related

- [index is not a btree](./index-is-not-a-btree.md)
- [no live root page found in index](./no-live-root-page-found-in-index.md)
