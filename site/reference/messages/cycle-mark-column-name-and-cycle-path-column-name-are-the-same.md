---
message: "cycle mark column name and cycle path column name are the same"
slug: cycle-mark-column-name-and-cycle-path-column-name-are-the-same
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_cte.c:534"
reproduced: false
---

# `cycle mark column name and cycle path column name are the same`

## What it means

A recursive `WITH ... CYCLE ... SET markcol USING pathcol` used the same name for the mark column and the path column. The clause adds two new columns, and they must have different names.

## When it happens

It happens when the `SET` name and the `USING` name in a `CYCLE` clause are identical.

## How to fix

Give the mark column and the path column distinct names. The mark column holds the cycle flag and the path column accumulates the visited rows, so they are separate outputs.

## Example

*Illustrative* — identical mark and path names.

```sql
WITH RECURSIVE w(id) AS (...) CYCLE id SET c USING c SELECT * FROM w;
-- ERROR:  cycle mark column name and cycle path column name are the same
```

## Related

- [cycle mark column name already used in WITH query column list](./cycle-mark-column-name-already-used-in-with-query-column-list.md)
- [cycle path column name already used in WITH query column list](./cycle-path-column-name-already-used-in-with-query-column-list.md)
