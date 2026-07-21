---
message: "\\crosstabview: column number %d is out of range 1..%d"
slug: crosstabview-column-number-is-out-of-range-1
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/crosstabview.c:670"
reproduced: false
---

# `\crosstabview: column number %d is out of range 1..%d`

## What it means

The `psql` `\crosstabview` command was given a column number outside the range of the query result. The placeholders are the number you gave and the valid upper bound.

## When it happens

It happens when you refer to a column by position in `\crosstabview` and that position is less than one or greater than the number of columns the query returned.

## How to fix

Use a column number between one and the number of columns in the result. Count the query's output columns and pass a position within that range, or name the column instead.

## Example

*Illustrative* — a position past the last column.

```text
\crosstabview: column number 5 is out of range 1..3
```

## Related

- [\crosstabview: column name not found](./crosstabview-column-name-not-found.md)
- [\crosstabview: maximum number of columns exceeded](./crosstabview-maximum-number-of-columns-exceeded.md)
