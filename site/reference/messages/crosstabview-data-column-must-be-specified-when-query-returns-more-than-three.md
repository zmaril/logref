---
message: "\\crosstabview: data column must be specified when query returns more than three columns"
slug: crosstabview-data-column-must-be-specified-when-query-returns-more-than-three
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/crosstabview.c:176"
reproduced: false
---

# `\crosstabview: data column must be specified when query returns more than three columns`

## What it means

The `psql` `\crosstabview` command needs an explicit data column because the query returned more than three columns. With exactly three columns it can infer the layout, but beyond that it cannot guess which column holds the values.

## When it happens

It happens when you run `\crosstabview` with no column arguments on a query that returns four or more columns.

## How to fix

Pass the column arguments explicitly: the horizontal header, the vertical header, and the data column. Naming them tells `\crosstabview` how to place the values. See its argument order in the `psql` documentation.

## Example

*Illustrative* — too many columns to infer the layout.

```text
\crosstabview: data column must be specified when query returns more than three columns
```

## Related

- [\crosstabview: query must return at least three columns](./crosstabview-query-must-return-at-least-three-columns.md)
- [\crosstabview: vertical and horizontal headers must be different columns](./crosstabview-vertical-and-horizontal-headers-must-be-different-columns.md)
