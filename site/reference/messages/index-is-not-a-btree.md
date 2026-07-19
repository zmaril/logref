---
message: "index \"%s\" is not a btree"
slug: index-is-not-a-btree
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/access/nbtree/nbtpage.c:156"
  - "postgres/src/backend/parser/parse_utilcmd.c:2508"
reproduced: false
---

# `index "%s" is not a btree`

## What it means

An operation that only works on btree indexes was given an index built with a different access method (such as GIN, GiST, or hash), or the index's metapage does not identify it as a btree. Depending on the caller it signals a wrong index type or btree corruption.

## When it happens

It comes from btree-specific tooling — `amcheck`'s `bt_index_check`, btree metadata inspection in `pageinspect`, or internal btree routines — when handed a non-btree index, or when a btree's metapage is unreadable.

## How to fix

Pass a btree index to btree-only functions. Check the index's access method with `\d indexname` or by querying `pg_am` via `pg_index`. If the index truly is a btree, the metapage may be damaged — rebuild it with `REINDEX INDEX`.

## Example

*Illustrative* — running a btree check on a GIN index.

```sql
SELECT bt_index_check('my_gin_idx');  -- not a btree
```

## Related

- [is not a BRIN index](./is-not-a-brin-index.md)
- [index internal pages traversal encountered leaf page unexpectedly on block](./index-internal-pages-traversal-encountered-leaf-page-unexpectedly-on-block.md)
