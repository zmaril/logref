---
message: "cannot create extended statistics on a single non-virtual column"
slug: cannot-create-extended-statistics-on-a-single-non-virtual-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/statscmds.c:411"
reproduced: false
---

# `cannot create extended statistics on a single non-virtual column`

## What it means

A `CREATE STATISTICS` named a single ordinary column. Extended statistics describe correlations across multiple columns, so a single-column statistics object is meaningful only for a virtual (expression) column, not a plain one.

## When it happens

It occurs when `CREATE STATISTICS` lists just one regular column rather than two or more columns or an expression.

## How to fix

List at least two columns for multi-column statistics, or define statistics over an expression for a single virtual column. Single ordinary columns already have per-column statistics from `ANALYZE`.

## Example

*Illustrative* — statistics on one plain column.

```sql
CREATE STATISTICS s ON a FROM t;
```

## Related

- [cannot create multivariate statistics on this expression](./cannot-create-multivariate-statistics-on-this-expression.md)
- [cannot define statistics for relation](./cannot-define-statistics-for-relation.md)
