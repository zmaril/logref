---
message: "invalid crosstab source data query"
slug: invalid-crosstab-source-data-query
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/contrib/tablefunc/tablefunc.c:422"
  - "postgres/contrib/tablefunc/tablefunc.c:851"
reproduced: true
---

# `invalid crosstab source data query`

## What it means

The `tablefunc` extension's `crosstab` function was given a source SQL query whose result does not have the shape it requires. A crosstab source query must return exactly the row-name, category, and value columns in order.

## When it happens

It arises when calling `crosstab(text)` or `crosstab(text, text)` with a source query that returns the wrong number of columns or columns in the wrong order for the pivot the function performs.

## How to fix

Shape the source query to return `(row_name, category, value)` — and for the two-argument form, ordered by `row_name` then `category`. Review the `tablefunc` documentation for the exact column contract, and adjust the query's `SELECT` list and `ORDER BY`.

## Example

*Reproduced* — captured from `reproducers/scenarios/42_contrib_inspection.sql`.

```sql
SELECT * FROM crosstab('SELECT 1') AS ct(a int, b int);
```

Produces:

```text
ERROR:  invalid crosstab source data query
```

## Related

- [invalid parameter list format](./invalid-parameter-list-format.md)
- [number of columns does not match number of values](./number-of-columns-does-not-match-number-of-values.md)
