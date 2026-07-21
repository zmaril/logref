---
message: "crosstab categories query must return at least one row"
slug: crosstab-categories-query-must-return-at-least-one-row
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CARDINALITY_VIOLATION
    code: "21000"
call_sites:
  - "postgres/contrib/tablefunc/tablefunc.c:832"
reproduced: false
---

# `crosstab categories query must return at least one row`

## What it means

The `crosstab` function from the `tablefunc` extension was given a categories query that returned no rows. That query supplies the set of output columns for the pivot, so it must produce at least one category.

## When it happens

It happens when you call the two-argument form of `crosstab()` and the second query — the one listing categories — comes back empty.

## How to fix

Make sure the categories query returns the distinct category values you want as columns. If it is filtered or joined in a way that yields nothing, adjust it so it returns at least one row. Test the categories query on its own first.

## Example

*Illustrative* — an empty categories query.

```sql
SELECT * FROM crosstab('SELECT rowid, cat, val FROM t', 'SELECT cat FROM cats WHERE false')
  AS ct(rowid text);
-- ERROR:  crosstab categories query must return at least one row
```

## Related

- [crosstab category value must not be null](./crosstab-category-value-must-not-be-null.md)
- [\crosstabview: query must return at least three columns](./crosstabview-query-must-return-at-least-three-columns.md)
