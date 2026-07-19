---
message: "cache lookup failed for attribute %d of relation %u"
slug: cache-lookup-failed-for-attribute-of-relation-12f5e3
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/aclchk.c:1625"
  - "postgres/src/backend/catalog/aclchk.c:1672"
  - "postgres/src/backend/catalog/heap.c:1728"
  - "postgres/src/backend/catalog/heap.c:2018"
  - "postgres/src/backend/catalog/heap.c:2070"
  - "postgres/src/backend/catalog/index.c:262"
  - "postgres/src/backend/catalog/index.c:1448"
  - "postgres/src/backend/catalog/pg_attrdef.c:96"
  - "postgres/src/backend/catalog/pg_attrdef.c:255"
  - "postgres/src/backend/commands/analyze.c:1199"
  - "postgres/src/backend/commands/repack.c:3569"
  - "postgres/src/backend/commands/tablecmds.c:8008"
  - "postgres/src/backend/commands/tablecmds.c:14709"
  - "postgres/src/backend/foreign/foreign.c:335"
  - "postgres/src/backend/parser/parse_relation.c:3530"
  - "postgres/src/backend/utils/cache/lsyscache.c:1070"
  - "postgres/src/backend/utils/cache/lsyscache.c:1124"
  - "postgres/src/backend/utils/cache/lsyscache.c:1179"
  - "postgres/src/backend/utils/cache/lsyscache.c:1208"
reproduced: false
---

# `cache lookup failed for attribute %d of relation %u`

## What it means

Internal error. A specific column (attribute) of a relation could not be found in the catalog (`pg_attribute`) by number. The first placeholder is the attribute number, the second the relation OID. Code expected the column to exist.

## When it happens

A concurrent `ALTER TABLE ... DROP COLUMN` or table drop racing with another operation, or catalog inconsistency. Not caused by ordinary data.

## How to fix

If it coincides with concurrent DDL on the table, retry. If it recurs, inspect `pg_attribute` for the relation and attribute number; a genuinely missing row indicates corruption and warrants restore from backup. Report reproducible cases.

## Example

*Illustrative* — a column dropped mid-operation.

```text
ERROR:  cache lookup failed for attribute 3 of relation 16600
```

## Related

- [cache lookup failed for relation](./cache-lookup-failed-for-relation-0e5774.md)
- [column %d of relation does not exist](./column-of-relation-does-not-exist-df5695.md)
