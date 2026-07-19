---
message: "a column definition list is only allowed for functions returning \"record\""
slug: a-column-definition-list-is-only-allowed-for-functions-returning-record
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_relation.c:1881"
reproduced: false
---

# `a column definition list is only allowed for functions returning "record"`

## What it means

A query attached a column-definition list (the `AS (col type, ...)` clause) to a function call, but that function does not return the generic `record` type, so specifying the columns is not allowed.

## When it happens

It occurs in a `FROM` clause when you write `func(...) AS (a int, b text)` for a function whose return type is already a concrete composite or scalar type rather than `record`.

## How to fix

Remove the column-definition list for functions that already declare their output columns; call them plainly as `SELECT * FROM func(...)`. Only functions declared to return `record` need — and permit — the `AS (...)` list.

## Example

*Illustrative* — a column list on a function that already types its output.

```sql
SELECT * FROM now() AS (t timestamptz);  -- column definition list not allowed here
```

## Related

- [a column definition list is required for functions returning record](./a-column-definition-list-is-required-for-functions-returning-record.md)
- [a column definition list is redundant for a function with OUT parameters](./a-column-definition-list-is-redundant-for-a-function-with-out-parameters.md)
