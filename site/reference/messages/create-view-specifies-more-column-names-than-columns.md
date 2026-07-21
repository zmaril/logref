---
message: "CREATE VIEW specifies more column names than columns"
slug: create-view-specifies-more-column-names-than-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/view.c:467"
reproduced: false
---

# `CREATE VIEW specifies more column names than columns`

## What it means

A `CREATE VIEW` statement supplied more column names in its parenthesized list than the view's query produces. Each name must line up with an output column of the query.

## When it happens

It happens when the column-name list after the view name is longer than the number of columns the `SELECT` returns.

## How to fix

Match the number of names to the number of output columns, or drop the explicit list and let the view take the query's column names. Count the columns the `SELECT` produces and align the list to them.

## Example

*Illustrative* — three names for a two-column query.

```sql
CREATE VIEW v (a, b, c) AS SELECT 1, 2;
-- ERROR:  CREATE VIEW specifies more column names than columns
```

## Related

- [CREATE STATISTICS only supports relation names in the FROM clause](./create-statistics-only-supports-relation-names-in-the-from-clause.md)
- [cycle column not in WITH query column list](./cycle-column-not-in-with-query-column-list.md)
