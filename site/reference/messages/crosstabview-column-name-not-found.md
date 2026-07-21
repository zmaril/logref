---
message: "\\crosstabview: column name not found: \"%s\""
slug: crosstabview-column-name-not-found
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/crosstabview.c:703"
reproduced: false
---

# `\crosstabview: column name not found: "%s"`

## What it means

The `psql` `\crosstabview` command was given a column name that does not appear in the query result. The placeholder is the name.

## When it happens

It happens when an argument to `\crosstabview` names a column that the preceding query did not return — a typo or a name that was aliased differently.

## How to fix

Check the column names the query actually produced and pass one of those. You can also reference a column by its position number. Run the query first to confirm the output column names, then rerun `\crosstabview`.

## Example

*Illustrative* — a name that is not in the result.

```text
\crosstabview: column name not found: "category"
```

## Related

- [\crosstabview: ambiguous column name](./crosstabview-ambiguous-column-name.md)
- [\crosstabview: column number is out of range](./crosstabview-column-number-is-out-of-range-1.md)
