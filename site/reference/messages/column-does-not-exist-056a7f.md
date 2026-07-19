---
message: "column %s.%s does not exist"
slug: column-does-not-exist-056a7f
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:405"
  - "postgres/src/backend/parser/parse_relation.c:3912"
  - "postgres/src/backend/parser/parse_relation.c:3922"
  - "postgres/src/backend/parser/parse_relation.c:3940"
  - "postgres/src/backend/parser/parse_relation.c:3947"
  - "postgres/src/backend/parser/parse_relation.c:3961"
reproduced: false
---

# `column %s.%s does not exist`

## What it means

A column reference could not be resolved. The two placeholders are a table (or alias) qualifier and the column name. Unlike the constraint-context forms, this is the parser failing to find `qualifier.column` among the query's visible columns.

## When it happens

Referencing `t.col` where `col` is not a column of `t`, using a table alias incorrectly, a typo in the column name, or referencing a column not in scope (for example from a table not in the `FROM` list, or before it is joined).

## How to fix

Check the column exists on that table/alias (`\d table`), and that the qualifier is in scope in this part of the query. Watch case sensitivity for quoted identifiers. If the column is from a joined table, ensure that table is in the `FROM`/`JOIN` and referenced by the right alias.

## Example

*Illustrative* — a mistyped qualified column.

```sql
SELECT u.emial FROM users u;
```

Produces:

```text
ERROR:  column u.emial does not exist
```

## Related

- [column "%s" of relation "%s" does not exist](./column-of-relation-does-not-exist-7bb9c5.md)
- [column %d of relation "%s" does not exist](./column-of-relation-does-not-exist-df5695.md)
