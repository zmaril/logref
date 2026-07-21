---
message: "a column definition list is required for functions returning \"record\""
slug: a-column-definition-list-is-required-for-functions-returning-record
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_relation.c:1892"
reproduced: false
---

# `a column definition list is required for functions returning "record"`

## What it means

A query called a function that returns the generic `record` type without telling the server what columns that record has, so the server cannot describe the result rows.

## When it happens

It occurs when a `record`-returning function (such as `json_to_record` or a custom function declared `RETURNS record`) is used in `FROM` without an `AS (col type, ...)` list.

## How to fix

Add a column-definition list that names and types each output column: `SELECT * FROM func(...) AS (id int, name text)`. The list must match the actual columns the function produces at runtime, since a `record` function does not carry that information in its declaration.

## Example

*Illustrative* — a record-returning function missing its column list.

```sql
SELECT * FROM json_to_record('{"id":1}');  -- ERROR: a column definition list is required
```

## Related

- [a column definition list is only allowed for functions returning record](./a-column-definition-list-is-only-allowed-for-functions-returning-record.md)
- [a column definition list is redundant for a function with OUT parameters](./a-column-definition-list-is-redundant-for-a-function-with-out-parameters.md)
