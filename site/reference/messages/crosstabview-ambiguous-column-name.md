---
message: "\\crosstabview: ambiguous column name: \"%s\""
slug: crosstabview-ambiguous-column-name
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/crosstabview.c:695"
reproduced: false
---

# `\crosstabview: ambiguous column name: "%s"`

## What it means

The `psql` `\crosstabview` command was given a column name that matches more than one column in the query result. The placeholder is the name. `\crosstabview` needs each column argument to identify exactly one column.

## When it happens

It happens when a name you pass to `\crosstabview` for the horizontal, vertical, or data column appears more than once in the result set, so it is not unique.

## How to fix

Make the column names in your query distinct, for example by giving explicit aliases, or refer to the column by its position number instead of its name. Then rerun `\crosstabview` with the unambiguous reference.

## Example

*Illustrative* — a duplicated column name.

```text
\crosstabview: ambiguous column name: "val"
```

## Related

- [\crosstabview: column name not found](./crosstabview-column-name-not-found.md)
- [\crosstabview: column number is out of range](./crosstabview-column-number-is-out-of-range-1.md)
