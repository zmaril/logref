---
message: "\\crosstabview: query result contains multiple data values for row \"%s\", column \"%s\""
slug: crosstabview-query-result-contains-multiple-data-values-for-row-column
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/src/bin/psql/crosstabview.c:399"
reproduced: false
---

# `\crosstabview: query result contains multiple data values for row "%s", column "%s"`

## What it means

The `psql` `\crosstabview` command found more than one value for the same cell — the same combination of vertical and horizontal header. The placeholders are the row and column. Each cell in the pivot can hold only one value.

## When it happens

It happens when the query returns duplicate rows for a (vertical, horizontal) pair, so `\crosstabview` cannot decide which value belongs in that cell.

## How to fix

Make the query produce one value per cell — aggregate the data (for example with `SUM` or `MAX` and `GROUP BY`) so each header combination appears once, or add the distinguishing column to the header so the pairs are unique.

## Example

*Illustrative* — two values for one cell.

```text
\crosstabview: query result contains multiple data values for row "east", column "2024"
```

## Related

- [\crosstabview: maximum number of columns exceeded](./crosstabview-maximum-number-of-columns-exceeded.md)
- [crosstab category value must not be null](./crosstab-category-value-must-not-be-null.md)
