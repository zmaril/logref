---
message: "complex graph table column must specify an explicit column name"
slug: complex-graph-table-column-must-specify-an-explicit-column-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:994"
reproduced: false
---

# `complex graph table column must specify an explicit column name`

## What it means

A `GRAPH_TABLE` column whose value comes from a complex expression was written without a column alias. Such columns need an explicit name because one cannot be inferred from the expression.

## When it happens

It happens in a `GRAPH_TABLE ... COLUMNS (...)` clause when a computed column lacks an `AS name` alias.

## How to fix

Add an explicit `AS name` to each complex graph-table column so it has a defined output name.

## Example

*Illustrative* — a complex graph-table column without a name.

```text
ERROR:  complex graph table column must specify an explicit column name
```

## Related

- [column name is not unique](./column-name-is-not-unique.md)
- [column notation applied to a non-composite type](./column-notation-applied-to-type-which-is-not-a-composite-type.md)
