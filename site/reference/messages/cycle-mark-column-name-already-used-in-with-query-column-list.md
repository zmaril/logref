---
message: "cycle mark column name \"%s\" already used in WITH query column list"
slug: cycle-mark-column-name-already-used-in-with-query-column-list
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_cte.c:519"
reproduced: false
---

# `cycle mark column name "%s" already used in WITH query column list`

## What it means

A recursive `WITH ... CYCLE ... SET markcol` used a mark-column name that already exists among the query's own columns. The placeholder is the name. The `SET` column is added by the `CYCLE` clause, so its name must not clash with an existing output column.

## When it happens

It happens when the name after `SET` in a `CYCLE` clause matches a column the recursive query already defines.

## How to fix

Choose a new, unused name for the cycle-mark column in the `SET` clause. It becomes an extra output column, so it must be distinct from the CTE's existing columns.

## Example

*Illustrative* — a mark-column name that collides.

```sql
WITH RECURSIVE w(id, is_cycle) AS (...) CYCLE id SET is_cycle USING path SELECT * FROM w;
-- ERROR:  cycle mark column name "is_cycle" already used in WITH query column list
```

## Related

- [cycle path column name already used in WITH query column list](./cycle-path-column-name-already-used-in-with-query-column-list.md)
- [cycle mark column name and cycle path column name are the same](./cycle-mark-column-name-and-cycle-path-column-name-are-the-same.md)
