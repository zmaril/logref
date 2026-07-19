---
message: "user-defined indexes on system catalog tables are not supported"
slug: user-defined-indexes-on-system-catalog-tables-are-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/catalog/index.c:803"
  - "postgres/src/backend/catalog/index.c:1937"
reproduced: false
---

# `user-defined indexes on system catalog tables are not supported`

## What it means

A statement tried to create a user index on a system catalog table, which PostgreSQL does not allow because the catalogs' indexes are fixed and managed by the system.

## When it happens

It arises from `CREATE INDEX` targeting a `pg_catalog` table. Even a superuser cannot add indexes to system catalogs through normal DDL.

## How to fix

Do not index system catalogs. If a catalog query is slow, address it another way — analyze your own workload, or use the catalog's existing indexes and system views. There is no supported route to add catalog indexes.

## Example

*Illustrative* — indexing a system catalog.

```text
ERROR:  user-defined indexes on system catalog tables are not supported
```

## Related

- [user "%s" cannot replicate into relation with row-level security enabled: "%s"](./user-cannot-replicate-into-relation-with-row-level-security-enabled.md)
- [WHERE CURRENT OF on a view is not implemented](./where-current-of-on-a-view-is-not-implemented.md)
