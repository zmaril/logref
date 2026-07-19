---
message: "\\crosstabview: query must return at least three columns"
slug: crosstabview-query-must-return-at-least-three-columns
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/crosstabview.c:133"
reproduced: false
---

# `\crosstabview: query must return at least three columns`

## What it means

The `psql` `\crosstabview` command needs a query that returns at least three columns: one for the vertical header, one for the horizontal header, and one for the data values.

## When it happens

It happens when you run `\crosstabview` on a query that returns fewer than three columns.

## How to fix

Rewrite the query so it produces at least three columns — the row key, the category, and the value to display. `\crosstabview` pivots the third column across the values of the second, grouped by the first.

## Example

*Illustrative* — a two-column query.

```text
\crosstabview: query must return at least three columns
```

## Related

- [\crosstabview: data column must be specified when query returns more than three columns](./crosstabview-data-column-must-be-specified-when-query-returns-more-than-three.md)
- [\crosstabview: statement did not return a result set](./crosstabview-statement-did-not-return-a-result-set.md)
