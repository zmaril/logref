---
message: "\\crosstabview: maximum number of columns (%d) exceeded"
slug: crosstabview-maximum-number-of-columns-exceeded
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/crosstabview.c:232"
reproduced: false
---

# `\crosstabview: maximum number of columns (%d) exceeded`

## What it means

The `psql` `\crosstabview` command produced more horizontal categories than it allows. The placeholder is the limit. The horizontal header's distinct values become output columns, and there is a cap on how many.

## When it happens

It happens when the column chosen as the horizontal header has more distinct values than the maximum number of display columns `\crosstabview` supports.

## How to fix

Reduce the number of distinct values in the horizontal header — filter the query, or choose a column with fewer categories for the horizontal axis. A pivot with hundreds of columns is rarely readable anyway; consider narrowing the data first.

## Example

*Illustrative* — too many horizontal categories.

```text
\crosstabview: maximum number of columns (1600) exceeded
```

## Related

- [\crosstabview: column number is out of range](./crosstabview-column-number-is-out-of-range-1.md)
- [\crosstabview: query result contains multiple data values for row, column](./crosstabview-query-result-contains-multiple-data-values-for-row-column.md)
