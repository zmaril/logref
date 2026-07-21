---
message: "cannot modify statistics for shared relation"
slug: cannot-modify-statistics-for-shared-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/statistics/stat_utils.c:232"
reproduced: false
---

# `cannot modify statistics for shared relation`

## What it means

A statistics-setting function targeted a shared catalog. Shared relations are visible to every database in the cluster, and their planner statistics cannot be modified through these functions.

## When it happens

It occurs when a manual-statistics or statistics-import function is pointed at a shared catalog such as `pg_database` or `pg_authid`.

## How to fix

Do not set statistics on shared catalogs. Let `ANALYZE` maintain them, and apply manual statistics only to regular per-database relations.

## Example

*Illustrative* — setting statistics on a shared catalog.

```text
ERROR:  cannot modify statistics for shared relation
```

## Related

- [cannot modify statistics for relation](./cannot-modify-statistics-for-relation.md)
- [cannot modify statistics on system column](./cannot-modify-statistics-on-system-column.md)
