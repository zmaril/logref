---
message: "\"%s\" is not a foreign table"
slug: is-not-a-foreign-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:1496"
  - "postgres/src/backend/commands/tablecmds.c:20389"
reproduced: false
---

# `"%s" is not a foreign table`

## What it means

A command that only applies to foreign tables was given a relation that is not one. The placeholder names the object.

## When it happens

It arises from foreign-table operations — `ALTER FOREIGN TABLE`, `IMPORT FOREIGN SCHEMA` targets, or foreign-table maintenance — when the named relation is an ordinary table, view, or other kind.

## How to fix

Name a foreign table, or use the command that matches the relation's actual kind. List foreign tables with `\det` in psql; use `ALTER TABLE` for ordinary tables instead of `ALTER FOREIGN TABLE`.

## Example

*Illustrative* — a foreign-table command on a regular table.

```sql
ALTER FOREIGN TABLE local_t OPTIONS (ADD x '1');  -- local_t is not foreign
```

## Related

- [is not a table or materialized view](./is-not-a-table-or-materialized-view.md)
- [is a table](./is-a-table.md)
