---
message: "cycle column \"%s\" not in WITH query column list"
slug: cycle-column-not-in-with-query-column-list
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_cte.c:503"
reproduced: false
---

# `cycle column "%s" not in WITH query column list`

## What it means

A recursive `WITH ... CYCLE` clause named a cycle-detection column that is not among the query's output columns. The placeholder is the column. The columns listed after `CYCLE` must be real columns of the recursive query.

## When it happens

It happens in a recursive CTE with a `CYCLE` clause when one of the columns you list to check for cycles does not appear in the CTE's column list.

## How to fix

List only columns that the recursive query actually produces after `CYCLE`. Check the spelling against the CTE's output columns and correct the clause.

## Example

*Illustrative* — a CYCLE column that is not in the query.

```sql
WITH RECURSIVE w(id) AS (...) CYCLE missing SET is_cycle USING path SELECT * FROM w;
-- ERROR:  cycle column "missing" not in WITH query column list
```

## Related

- [cycle column specified more than once](./cycle-column-specified-more-than-once.md)
- [cycle mark column name already used in WITH query column list](./cycle-mark-column-name-already-used-in-with-query-column-list.md)
