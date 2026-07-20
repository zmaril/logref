---
message: "\\crosstabview: vertical and horizontal headers must be different columns"
slug: crosstabview-vertical-and-horizontal-headers-must-be-different-columns
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/crosstabview.c:160"
reproduced: false
---

# `\crosstabview: vertical and horizontal headers must be different columns`

## What it means

The `psql` `\crosstabview` command was told to use the same column for both the vertical and the horizontal header. The two axes of the pivot must come from different columns.

## When it happens

It happens when the column arguments for the vertical and horizontal headers resolve to the same column of the result.

## How to fix

Choose two distinct columns for the two axes. One column supplies the row labels and a different one supplies the column labels. Correct the arguments so they name different columns.

## Example

*Illustrative* — both axes point at one column.

```text
\crosstabview: vertical and horizontal headers must be different columns
```

## Related

- [\crosstabview: data column must be specified when query returns more than three columns](./crosstabview-data-column-must-be-specified-when-query-returns-more-than-three.md)
- [\crosstabview: column name not found](./crosstabview-column-name-not-found.md)
