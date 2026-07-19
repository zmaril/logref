---
message: "cycle path column name \"%s\" already used in WITH query column list"
slug: cycle-path-column-name-already-used-in-with-query-column-list
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_cte.c:526"
reproduced: false
---

# `cycle path column name "%s" already used in WITH query column list`

## What it means

A recursive `WITH ... CYCLE ... USING pathcol` used a path-column name that already exists among the query's own columns. The placeholder is the name. The path column is added by the `CYCLE` clause and must not clash with an existing column.

## When it happens

It happens when the name after `USING` in a `CYCLE` clause matches a column the recursive query already defines.

## How to fix

Choose an unused name for the path column in the `USING` clause. It becomes an extra output column that records the traversal path, so it must be distinct from the CTE's existing columns.

## Example

*Illustrative* — a path-column name that collides.

```sql
WITH RECURSIVE w(id, path) AS (...) CYCLE id SET is_cycle USING path SELECT * FROM w;
-- ERROR:  cycle path column name "path" already used in WITH query column list
```

## Related

- [cycle mark column name already used in WITH query column list](./cycle-mark-column-name-already-used-in-with-query-column-list.md)
- [cycle mark column name and cycle path column name are the same](./cycle-mark-column-name-and-cycle-path-column-name-are-the-same.md)
