---
message: "index \"%s\" contains corrupted page at block %u"
slug: index-contains-corrupted-page-at-block
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INDEX_CORRUPTED
    code: "XX002"
call_sites:
  - "postgres/contrib/amcheck/verify_gin.c:687"
  - "postgres/contrib/pgstattuple/pgstatindex.c:705"
  - "postgres/src/backend/access/gist/gistutil.c:807"
  - "postgres/src/backend/access/hash/hashutil.c:232"
  - "postgres/src/backend/access/hash/hashutil.c:244"
  - "postgres/src/backend/access/nbtree/nbtpage.c:804"
reproduced: false
---

# `index "%s" contains corrupted page at block %u`

## What it means

An index scan or check found a page that fails validation. The first placeholder is the index name, the second the block number. The page's structure is not a valid index page for its type, indicating index corruption. The `INDEX_CORRUPTED` SQLSTATE marks it as an integrity failure.

## When it happens

Reading or verifying a damaged index — from failing storage, an interrupted operation, a software bug, or replay of a bad WAL record. `amcheck` and normal scans both can surface it. The underlying table data may still be intact.

## How to fix

Rebuild the index: `REINDEX INDEX name` (or `REINDEX INDEX CONCURRENTLY name`) recreates it from the table, which usually resolves index-only corruption. If reindex fails or corruption recurs, investigate storage health and check the table itself with `amcheck`/heap checks. If a bug is suspected, capture the case and report it after rebuilding.

## Example

*Illustrative* — a scan hitting a corrupt index page.

```text
ERROR:  index "orders_pkey" contains corrupted page at block 42
```

## Related

- [corrupted page pointers: lower = %u, upper = %u, special = %u](./corrupted-page-pointers-lower-upper-special.md)
- [index "%s" is not valid](./index-is-not-valid.md)
