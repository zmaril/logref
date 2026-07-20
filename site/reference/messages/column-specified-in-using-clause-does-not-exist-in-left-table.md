---
message: "column \"%s\" specified in USING clause does not exist in left table"
slug: column-specified-in-using-clause-does-not-exist-in-left-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:1499"
reproduced: false
---

# `column "%s" specified in USING clause does not exist in left table`

## What it means

A join's `USING` clause named a column that is not present in the left-hand table of the join. Every `USING` column must exist on both sides.

## When it happens

It happens with `t1 JOIN t2 USING (col)` when `col` does not exist in `t1`.

## How to fix

Use a column that exists in the left table, or switch to an explicit `ON` condition if the join columns have different names. Check the left table's columns.

## Example

*Illustrative* — a USING column missing from the left table.

```sql
SELECT * FROM t1 JOIN t2 USING (missing);
-- ERROR:  column "missing" specified in USING clause does not exist in left table
```

## Related

- [column specified in USING clause does not exist in right table](./column-specified-in-using-clause-does-not-exist-in-right-table.md)
- [column name appears more than once in USING clause](./column-name-appears-more-than-once-in-using-clause.md)
