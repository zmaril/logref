---
message: "cannot add schema \"%s\" to publication"
slug: cannot-add-schema-to-publication-d50742
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/catalog/pg_publication.c:125"
  - "postgres/src/backend/catalog/pg_publication.c:133"
reproduced: false
---

# `cannot add schema "%s" to publication`

## What it means

A publication command tried to add a schema that cannot be added to a publication. The placeholder is the schema name. Certain schemas — the temporary schema and system schemas such as `pg_catalog` — are not valid targets for schema-level publication membership.

## When it happens

`CREATE PUBLICATION ... FOR TABLES IN SCHEMA` or `ALTER PUBLICATION ... ADD TABLES IN SCHEMA` naming a system schema or a temporary schema.

## How to fix

Publish only user schemas. If you need specific system or temporary objects replicated, that is not supported through schema-level publication; publish ordinary user tables instead. Correct the schema name in the command.

## Example

*Illustrative* — adding a system schema to a publication.

```sql
ALTER PUBLICATION p ADD TABLES IN SCHEMA pg_catalog;
-- ERROR:  cannot add schema "pg_catalog" to publication
```

## Related

- [conflicting or redundant column lists for table](./conflicting-or-redundant-column-lists-for-table.md)
- [cannot use column list for relation in publication](./cannot-use-column-list-for-relation-in-publication.md)
