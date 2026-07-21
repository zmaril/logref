---
message: "crosstab category value must not be null"
slug: crosstab-category-value-must-not-be-null
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NULL_VALUE_NOT_ALLOWED
    code: "22004"
call_sites:
  - "postgres/contrib/tablefunc/tablefunc.c:765"
reproduced: false
---

# `crosstab category value must not be null`

## What it means

The `crosstab` function's categories query returned a null category value. Each category becomes an output column, and a null cannot name a column, so the function rejects it.

## When it happens

It happens with the two-argument form of `crosstab()` when the categories query yields a row whose category value is null.

## How to fix

Filter nulls out of the categories query, for example with `WHERE cat IS NOT NULL`, or map them to a concrete label with `COALESCE`. Every category must be a non-null value.

## Example

*Illustrative* — a null category.

```sql
SELECT * FROM crosstab('SELECT rowid, cat, val FROM t', 'SELECT DISTINCT cat FROM t')
  AS ct(rowid text, a int, b int);
-- ERROR:  crosstab category value must not be null
```

## Related

- [crosstab categories query must return at least one row](./crosstab-categories-query-must-return-at-least-one-row.md)
- [\crosstabview: query result contains multiple data values for row, column](./crosstabview-query-result-contains-multiple-data-values-for-row-column.md)
