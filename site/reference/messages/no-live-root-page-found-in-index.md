---
message: "no live root page found in index \"%s\""
slug: no-live-root-page-found-in-index
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/nbtree/nbtpage.c:552"
  - "postgres/src/backend/access/nbtree/nbtpage.c:635"
reproduced: false
---

# `no live root page found in index "%s"`

## What it means

Internal error. An index scan or maintenance operation could not locate a live root page for the index. The placeholder is the index name. A valid index always has a reachable root; its absence signals index damage.

## When it happens

It fires from access-method code (notably btree/SP-GiST) when following the metapage to the root yields no live page. Ordinary index use does not surface it; it points to a corrupted or interrupted index build.

## How to fix

Rebuild the index with `REINDEX INDEX`. If the problem returns after a rebuild, investigate storage for I/O errors. Record the index name and the operation that triggered it.

## Example

*Illustrative* — no reachable root page in an index.

```text
ERROR:  no live root page found in index "my_idx"
```

## Related

- [index internal pages traversal encountered leaf page unexpectedly on block](./index-internal-pages-traversal-encountered-leaf-page-unexpectedly-on-block.md)
- [no data returned for index-only scan](./no-data-returned-for-index-only-scan.md)
