---
message: "number of items mismatch in GIN entry tuple, %d in tuple header, %d decoded"
slug: number-of-items-mismatch-in-gin-entry-tuple-in-tuple-header-decoded
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/amcheck/verify_gin.c:112"
  - "postgres/src/backend/access/gin/ginentrypage.c:176"
reproduced: false
---

# `number of items mismatch in GIN entry tuple, %d in tuple header, %d decoded`

## What it means

Internal error. A GIN index entry tuple recorded one item count in its header but decoded a different number of posting-list items. The placeholders are the header count and the decoded count. It signals GIN index inconsistency.

## When it happens

It fires while reading a GIN entry tuple whose header and posting list disagree. Ordinary GIN queries do not surface it; it points to a corrupted GIN index or an interrupted build.

## How to fix

Rebuild the index with `REINDEX INDEX`. If it recurs, investigate storage for I/O errors. Capture the index name and the query that triggered it.

## Example

*Illustrative* — a GIN entry tuple item-count mismatch.

```text
ERROR:  number of items mismatch in GIN entry tuple, 5 in tuple header, 4 decoded
```

## Related

- [input page is not a valid GIN data leaf page](./input-page-is-not-a-valid-gin-data-leaf-page.md)
- [index is not a btree](./index-is-not-a-btree.md)
