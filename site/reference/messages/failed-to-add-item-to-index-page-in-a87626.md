---
message: "failed to add item to index page in \"%s\""
slug: failed-to-add-item-to-index-page-in-a87626
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/access/gin/ginentrypage.c:570"
  - "postgres/src/backend/access/gin/ginentrypage.c:688"
  - "postgres/src/backend/access/gin/ginfast.c:89"
  - "postgres/src/backend/access/gin/ginfast.c:390"
  - "postgres/src/backend/access/gin/ginvacuum.c:589"
  - "postgres/src/backend/access/gist/gist.c:435"
  - "postgres/src/backend/access/gist/gist.c:556"
  - "postgres/src/backend/access/gist/gistbuild.c:562"
reproduced: false
---

# `failed to add item to index page in "%s"`

## What it means

Internal error. An index build or insert (GIN, GiST, or similar) tried to place an item on a page and the page manager rejected it. The placeholder is the index name. It usually indicates that an item does not fit or an index page-accounting inconsistency.

## When it happens

Building or inserting into a GIN/GiST index where an entry is too large for a page, a bug in a custom operator class, or index corruption. Very large indexed values are a common trigger.

## How to fix

If the indexed values are unusually large, index a smaller expression (a hash, a prefix, or specific fields) instead of the whole value. If a custom opclass is involved, suspect it. For possible corruption, `REINDEX` the named index. Report reproducible cases against a specific opclass/data.

## Example

*Illustrative* — an oversized GIN entry.

```text
ERROR:  failed to add item to index page in "idx_docs_gin"
```

## Related

- [failed to add item of size %u to SPGiST index page](./failed-to-add-item-of-size-to-spgist-index-page-63086a.md)
- [index row size %zu exceeds maximum](./index-row-size-exceeds-maximum-for-index-8f3043.md)
