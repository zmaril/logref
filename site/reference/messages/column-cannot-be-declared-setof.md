---
message: "column \"%s\" cannot be declared SETOF"
slug: column-cannot-be-declared-setof
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:1485"
  - "postgres/src/backend/parser/parse_clause.c:776"
  - "postgres/src/backend/parser/parse_relation.c:1948"
reproduced: false
---

# `column "%s" cannot be declared SETOF`

## What it means

A column definition used `SETOF`, which is only valid for function result types, not for columns. The placeholder names the column. `SETOF` describes a function returning a set of rows; a table column holds a single value per row and cannot be set-returning.

## When it happens

Writing `SETOF` in a `CREATE TABLE` column, a composite-type field, or another column definition context — usually a misplaced function-return syntax.

## How to fix

Remove `SETOF` from the column definition and give the column a plain type. If you need a column holding multiple values, use an array type or a separate related table. `SETOF` belongs only in a function's `RETURNS` clause.

## Example

*Illustrative* — SETOF on a column.

```sql
CREATE TABLE t (c SETOF int);  -- column "c" cannot be declared SETOF
```

## Related

- [cannot determine result data type](./cannot-determine-result-data-type.md)
- [column of relation is an identity column](./column-of-relation-is-an-identity-column.md)
