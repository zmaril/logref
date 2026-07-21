---
message: "a column definition list is redundant for a function returning a named composite type"
slug: a-column-definition-list-is-redundant-for-a-function-returning-a-named
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_relation.c:1874"
reproduced: false
---

# `a column definition list is redundant for a function returning a named composite type`

## What it means

A function call supplied a column-definition list, but the function already returns a named composite type whose columns are known, so the list adds nothing and is rejected as redundant.

## When it happens

It occurs when you write `func(...) AS (...)` for a set-returning or scalar function whose return type is a specific named row type rather than the anonymous `record` type.

## How to fix

Drop the `AS (...)` list — the function's declared composite type already provides the column names and types. Use `SELECT * FROM func(...)` and reference the columns directly.

## Example

*Illustrative* — a redundant column list on a named-composite-returning function.

```sql
SELECT * FROM get_row(1) AS (id int, name text);  -- redundant: get_row returns a named type
```

## Related

- [a column definition list is redundant for a function with OUT parameters](./a-column-definition-list-is-redundant-for-a-function-with-out-parameters.md)
- [a column definition list is only allowed for functions returning record](./a-column-definition-list-is-only-allowed-for-functions-returning-record.md)
