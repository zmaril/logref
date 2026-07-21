---
message: "column list must not be specified in ALTER PUBLICATION ... DROP"
slug: column-list-must-not-be-specified-in-alter-publication-drop
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/publicationcmds.c:2083"
reproduced: false
---

# `column list must not be specified in ALTER PUBLICATION ... DROP`

## What it means

An `ALTER PUBLICATION ... DROP TABLE` statement included a column list. Dropping a table from a publication removes the whole table entry, so naming individual columns is not meaningful and is rejected.

## When it happens

It happens on `ALTER PUBLICATION ... DROP TABLE tab (col, ...)` — the column list is only valid when adding or setting a table, not when dropping one.

## How to fix

Remove the column list from the `DROP TABLE` clause. To change which columns a publication carries, use `ALTER PUBLICATION ... SET TABLE tab (cols)` instead.

## Example

*Illustrative* — a column list given to DROP TABLE.

```sql
ALTER PUBLICATION p DROP TABLE t (a, b);
-- ERROR:  column list must not be specified in ALTER PUBLICATION ... DROP
```

## Related

- [cannot alter type of a column used by a publication WHERE clause](./cannot-alter-type-of-a-column-used-by-a-publication-where-clause.md)
- [column name specified more than once](./column-name-specified-more-than-once.md)
