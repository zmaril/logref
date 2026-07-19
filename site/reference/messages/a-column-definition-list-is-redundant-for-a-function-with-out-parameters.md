---
message: "a column definition list is redundant for a function with OUT parameters"
slug: a-column-definition-list-is-redundant-for-a-function-with-out-parameters
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_relation.c:1868"
reproduced: false
---

# `a column definition list is redundant for a function with OUT parameters`

## What it means

A function call supplied a column-definition list, but the function already declares its output shape through `OUT` (or `INOUT`) parameters, so restating the columns is redundant and rejected.

## When it happens

It occurs when you write `func(...) AS (...)` for a function whose signature includes `OUT` parameters that already name and type each output column.

## How to fix

Remove the `AS (...)` list — the `OUT` parameters define the result columns. Call the function as `SELECT * FROM func(...)` and use the parameter names.

## Example

*Illustrative* — a redundant column list on an OUT-parameter function.

```sql
SELECT * FROM split_name('a b') AS (first text, last text);  -- redundant with OUT params
```

## Related

- [a column definition list is redundant for a function returning a named composite type](./a-column-definition-list-is-redundant-for-a-function-returning-a-named.md)
- [a column definition list is only allowed for functions returning record](./a-column-definition-list-is-only-allowed-for-functions-returning-record.md)
