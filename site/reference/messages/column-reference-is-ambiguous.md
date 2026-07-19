---
message: "column reference \"%s\" is ambiguous"
slug: column-reference-is-ambiguous
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_AMBIGUOUS_COLUMN
    code: "42702"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:859"
  - "postgres/src/backend/parser/parse_relation.c:874"
  - "postgres/src/backend/parser/parse_relation.c:956"
  - "postgres/src/backend/parser/parse_target.c:1244"
  - "postgres/src/pl/plpgsql/src/pl_comp.c:1045"
reproduced: false
---

# `column reference "%s" is ambiguous`

## What it means

A column name in a query matched more than one available source, so Postgres cannot tell which one you meant. The placeholder is the column name. It appears when two joined tables share a column name, or a name matches both a table column and something else in scope.

## When it happens

Selecting or filtering on an unqualified column that exists in multiple tables of a join, or that collides with a `USING`/`NATURAL JOIN` column, a subquery output, or a PL/pgSQL variable of the same name.

## How to fix

Qualify the reference with its table name or alias (`t.id` rather than `id`). In joins, alias the tables and prefix every shared column. In PL/pgSQL, rename variables that clash with column names or qualify columns with the table name.

## Example

*Illustrative* — an unqualified column present in both joined tables.

```sql
SELECT id FROM a JOIN b ON a.id = b.a_id;
```

## Related

- [column specified more than once](./column-specified-more-than-once.md)
- [record has no field](./record-has-no-field.md)
