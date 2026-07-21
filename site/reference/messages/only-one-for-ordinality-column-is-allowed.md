---
message: "only one FOR ORDINALITY column is allowed"
slug: only-one-for-ordinality-column-is-allowed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:764"
  - "postgres/src/backend/parser/parse_jsontable.c:394"
reproduced: false
---

# `only one FOR ORDINALITY column is allowed`

## What it means

A `JSON_TABLE` or `ROWS FROM ... WITH ORDINALITY`-style construct declared more than one `FOR ORDINALITY` column. Only a single ordinality column is permitted, since there is one row-position value.

## When it happens

It arises in `JSON_TABLE(... COLUMNS (n FOR ORDINALITY, m FOR ORDINALITY, ...))` when two columns are both declared `FOR ORDINALITY`.

## How to fix

Declare at most one `FOR ORDINALITY` column. Keep the single ordinality column you need and define the others as ordinary value columns.

## Example

*Illustrative* — two ordinality columns.

```sql
JSON_TABLE(js, '$' COLUMNS (a FOR ORDINALITY, b FOR ORDINALITY))  -- only one allowed
```

## Related

- [JSON path expression for column must return single scalar item](./json-path-expression-for-column-must-return-single-scalar-item.md)
- [only a single relation is allowed in CREATE STATISTICS](./only-a-single-relation-is-allowed-in-create-statistics.md)
