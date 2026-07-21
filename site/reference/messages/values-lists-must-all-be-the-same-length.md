---
message: "VALUES lists must all be the same length"
slug: values-lists-must-all-be-the-same-length
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/analyze.c:910"
  - "postgres/src/backend/parser/analyze.c:1965"
reproduced: true
---

# `VALUES lists must all be the same length`

## What it means

A `VALUES` clause with multiple rows has rows with differing numbers of columns, so PostgreSQL cannot form a consistent result shape.

## When it happens

It arises from a multi-row `VALUES (...), (...)` (in an `INSERT`, a `VALUES` query, or a CTE) where one row lists more or fewer expressions than another.

## How to fix

Give every row in the `VALUES` list the same number of columns. Add or remove expressions so each parenthesized row matches; a stray or missing comma is a common cause.

## Example

*Reproduced* — captured from `reproducers/scenarios/23_query_semantics_extended.sql`.

```sql
VALUES (1,2), (3);
```

Produces:

```text
ERROR:  VALUES lists must all be the same length
```

## Related

- [wrong number of output columns in WITH](./wrong-number-of-output-columns-in-with.md)
- [value %s out of bounds for option "%s"](./value-out-of-bounds-for-option.md)
