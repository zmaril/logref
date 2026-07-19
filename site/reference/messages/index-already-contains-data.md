---
message: "index \"%s\" already contains data"
slug: index-already-contains-data
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/bloom/blinsert.c:129"
  - "postgres/src/backend/access/brin/brin.c:1124"
  - "postgres/src/backend/access/gin/gininsert.c:634"
  - "postgres/src/backend/access/gist/gistbuild.c:194"
  - "postgres/src/backend/access/hash/hash.c:150"
  - "postgres/src/backend/access/nbtree/nbtsort.c:324"
  - "postgres/src/backend/access/spgist/spginsert.c:83"
reproduced: false
---

# `index "%s" already contains data`

## What it means

Internal error. An index build tried to initialize an index relation that unexpectedly already has data in it. The placeholder is the index name. Index builds expect to start from an empty index relation; finding data indicates an inconsistency.

## When it happens

A bug in index-build code, a concurrent operation touching the index being built, or catalog/storage inconsistency. Ordinary `CREATE INDEX` on a fresh index does not trigger it.

## How to fix

Drop and recreate the index. If it recurs, suspect corruption or a concurrency bug — check for other operations touching the relation and verify storage health. Reproducible cases with the exact sequence are worth reporting.

## Example

*Illustrative* — an index build finding unexpected data.

```text
ERROR:  index "idx_t_x" already contains data
```

## Related

- [index is not valid](./index-is-not-valid.md)
- [failed to add item to index page in](./failed-to-add-item-to-index-page-in-a87626.md)
