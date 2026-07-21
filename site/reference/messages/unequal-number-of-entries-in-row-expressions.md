---
message: "unequal number of entries in row expressions"
slug: unequal-number-of-entries-in-row-expressions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:2877"
  - "postgres/src/backend/parser/parse_expr.c:3073"
reproduced: true
---

# `unequal number of entries in row expressions`

## What it means

A row comparison or row-valued expression put two rows of different widths on each side. The placeholder-free message reports that the row constructors have unequal numbers of fields, so they cannot be compared element-by-element.

## When it happens

It arises from `ROW(...) = ROW(...)` (or an `IN`/comparison over row values) where the two rows have different numbers of columns.

## How to fix

Make both sides of the row comparison have the same number of fields. Adjust the row constructors so they line up column-for-column, or compare only the columns that correspond.

## Example

*Reproduced* — captured from `reproducers/scenarios/33_grant_roles_coerce_dml.sql`.

```sql
SELECT ROW(1,2) = ROW(1,2,3);
```

Produces:

```text
ERROR:  unequal number of entries in row expressions
```

## Related

- [subquery must return only one column](./subquery-must-return-only-one-column.md)
- [too many column names were specified](./too-many-column-names-were-specified.md)
