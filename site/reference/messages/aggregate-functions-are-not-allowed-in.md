---
message: "aggregate functions are not allowed in %s"
slug: aggregate-functions-are-not-allowed-in
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_GROUPING_ERROR
    code: "42803"
call_sites:
  - "postgres/src/backend/parser/parse_clause.c:2107"
reproduced: false
---

# `aggregate functions are not allowed in %s`

## What it means

An aggregate function was used in a clause or context that does not permit aggregates, so the query is invalid where it stands.

## When it happens

It occurs when an aggregate appears somewhere it is not allowed — for example in a `WHERE` clause, a `CHECK` constraint, an index expression, or a `DEFAULT`, rather than in a select list or `HAVING`.

## How to fix

Move the aggregate to a place aggregates are allowed. Use `HAVING` instead of `WHERE` to filter on aggregate results, or compute the aggregate in a subquery and reference it in the outer query. Aggregates cannot appear in `WHERE`, constraints, or index/default expressions.

## Example

*Illustrative* — an aggregate in a WHERE clause.

```sql
SELECT * FROM t WHERE sum(x) > 10;  -- use HAVING with GROUP BY instead
```

## Related

- [aggregate functions are not allowed in a recursive query's recursive term](./aggregate-functions-are-not-allowed-in-a-recursive-query-s-recursive-term.md)
- [aggregate function calls cannot contain window function calls](./aggregate-function-calls-cannot-contain-window-function-calls.md)
