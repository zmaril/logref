---
message: "index row size %zu exceeds maximum %zu for index \"%s\""
slug: index-row-size-exceeds-maximum-for-index-8f3043
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/src/backend/access/brin/brin_pageops.c:73"
  - "postgres/src/backend/access/brin/brin_pageops.c:358"
  - "postgres/src/backend/access/brin/brin_pageops.c:847"
  - "postgres/src/backend/access/gin/ginentrypage.c:107"
  - "postgres/src/backend/access/gist/gist.c:1473"
  - "postgres/src/backend/access/spgist/spgdoinsert.c:1994"
  - "postgres/src/backend/access/spgist/spgdoinsert.c:2271"
reproduced: false
---

# `index row size %zu exceeds maximum %zu for index "%s"`

## What it means

An index tuple was too large to fit. The placeholders are the row size, the maximum, and the index name. B-tree and some other index types require each index entry to fit within roughly a third of a page (about 2704 bytes for the default 8 KB page); a larger indexed value cannot be stored.

## When it happens

Indexing a long text/bytea column (or a multi-column key whose combined size is large) with a b-tree, and inserting a row whose indexed value exceeds the per-entry limit. It fires at insert or index-build time on the oversized value.

## How to fix

Do not b-tree index the full large value. Index a hash of it (`CREATE INDEX ON t (md5(col))` or a hash index for equality), a prefix (`CREATE INDEX ON t (left(col, 100))`), or use a type designed for large text search (a GIN index with `to_tsvector`, or `pg_trgm`). For uniqueness on long values, a unique index on a hash plus an equality check is a common pattern.

## Example

*Illustrative* — b-tree indexing an over-long value.

```sql
CREATE INDEX ON docs (body);
INSERT INTO docs (body) VALUES (repeat('x', 5000));
```

Produces:

```text
ERROR:  index row size 5016 exceeds maximum 2704 for index "docs_body_idx"
```

## Related

- [array size exceeds the maximum allowed](./array-size-exceeds-the-maximum-allowed-075b47.md)
- [failed to add item to index page in](./failed-to-add-item-to-index-page-in-a87626.md)
