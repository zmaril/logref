---
message: "column name \"%s\" appears more than once in USING clause"
slug: column-name-appears-more-than-once-in-using-clause
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_COLUMN
    code: "42701"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:1475"
reproduced: false
---

# `column name "%s" appears more than once in USING clause`

## What it means

A join's `USING` clause listed the same column name twice. Each column in a `USING` list joins one column from each side, so a repeated name is redundant and rejected.

## When it happens

It happens when a query writes `JOIN ... USING (a, a)` or otherwise repeats a column in the `USING` list.

## How to fix

List each join column only once in the `USING` clause. If you meant to join on two different columns, correct the names.

## Example

*Illustrative* — a repeated column in USING.

```sql
SELECT * FROM t1 JOIN t2 USING (a, a);
-- ERROR:  column name "a" appears more than once in USING clause
```

## Related

- [common column name appears more than once in left table](./common-column-name-appears-more-than-once-in-left-table.md)
- [column specified in USING clause does not exist in left table](./column-specified-in-using-clause-does-not-exist-in-left-table.md)
