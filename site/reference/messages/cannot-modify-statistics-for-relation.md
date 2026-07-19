---
message: "cannot modify statistics for relation \"%s\""
slug: cannot-modify-statistics-for-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/statistics/stat_utils.c:224"
reproduced: false
---

# `cannot modify statistics for relation "%s"`

## What it means

A statistics-import or manual-statistics function targeted a relation whose kind does not accept modified statistics. The relation is of a type that has no user-adjustable planner statistics. The placeholder is the relation name.

## When it happens

It occurs when a function such as `pg_restore_relation_stats()` or a related statistics-setting routine is pointed at an object that cannot hold the statistics being set.

## How to fix

Apply statistics only to relations that support them (ordinary tables, materialized views, and indexes as applicable). Choose a supported target, or let `ANALYZE` gather statistics normally.

## Example

*Illustrative* — setting statistics on an unsupported relation.

```text
ERROR:  cannot modify statistics for relation "my_view"
```

## Related

- [cannot modify statistics for shared relation](./cannot-modify-statistics-for-shared-relation.md)
- [cannot modify statistics on system column](./cannot-modify-statistics-on-system-column.md)
