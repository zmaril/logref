---
message: "duplicate column \"%s\" in publication column list"
slug: duplicate-column-in-publication-column-list
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/catalog/pg_publication.c:715"
reproduced: false
---

# `duplicate column "%s" in publication column list`

## What it means

A `CREATE PUBLICATION` or `ALTER PUBLICATION` column list named the same column twice for a table. The placeholder is the column name. Each column may appear at most once in a publication's column list.

## When it happens

It fires when defining a publication with an explicit column list that repeats a column.

## How to fix

List each column once in the publication's column list. Remove the duplicate name.

## Example

*Illustrative* — a repeated column in a publication list.

```sql
CREATE PUBLICATION p FOR TABLE t (id, id);
-- duplicate column "id" in publication column list
```

## Related

- [duplicate column name in statistics definition](./duplicate-column-name-in-statistics-definition.md)
- [duplicate expression in statistics definition](./duplicate-expression-in-statistics-definition.md)
