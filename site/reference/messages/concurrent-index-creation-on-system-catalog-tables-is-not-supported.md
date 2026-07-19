---
message: "concurrent index creation on system catalog tables is not supported"
slug: concurrent-index-creation-on-system-catalog-tables-is-not-supported
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/catalog/index.c:858"
reproduced: false
---

# `concurrent index creation on system catalog tables is not supported`

## What it means

A `CREATE INDEX CONCURRENTLY` (or `REINDEX ... CONCURRENTLY`) targeted a system catalog. Concurrent index builds are not allowed on catalogs, because the catalogs are needed to run the build itself.

## When it happens

It happens on `CREATE INDEX CONCURRENTLY` against a `pg_catalog` table, or `REINDEX CONCURRENTLY` on a catalog.

## How to fix

Build the index without `CONCURRENTLY` (a plain `CREATE INDEX` or `REINDEX`), accepting the lock it takes. Concurrent builds are only supported on user tables.

## Example

*Illustrative* — a concurrent index on a catalog.

```sql
CREATE INDEX CONCURRENTLY ON pg_class (relname);
-- ERROR:  concurrent index creation on system catalog tables is not supported
```

## Related

- [CONCURRENTLY cannot be used when the materialized view is not populated](./concurrently-cannot-be-used-when-the-materialized-view-is-not-populated.md)
- [CONCURRENTLY option not supported for](./concurrently-option-not-supported-for.md)
