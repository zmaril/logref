---
message: "CREATE STATISTICS only supports relation names in the FROM clause"
slug: create-statistics-only-supports-relation-names-in-the-from-clause
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/tcop/utility.c:1896"
reproduced: false
---

# `CREATE STATISTICS only supports relation names in the FROM clause`

## What it means

A `CREATE STATISTICS` statement referenced something other than a plain table in its `FROM` clause. Extended statistics can only be built over the columns of a single ordinary relation, not over a subquery, join, or function.

## When it happens

It happens when the `FROM` clause of `CREATE STATISTICS` names anything but one table — for example a join, a subquery, or a set-returning function.

## How to fix

Rewrite the statement so `FROM` names a single table, and list the columns of that table in the statistics expression. Extended statistics describe correlations among columns of one relation; if you need cross-table insight, that is not what this feature provides.

## Example

*Illustrative* — a join in the FROM clause.

```sql
CREATE STATISTICS s ON a, b FROM t1 JOIN t2 ON t1.id = t2.id;
-- ERROR:  CREATE STATISTICS only supports relation names in the FROM clause
```

## Related

- [CREATE VIEW specifies more column names than columns](./create-view-specifies-more-column-names-than-columns.md)
- [data type is not an array type](./data-type-is-not-an-array-type.md)
