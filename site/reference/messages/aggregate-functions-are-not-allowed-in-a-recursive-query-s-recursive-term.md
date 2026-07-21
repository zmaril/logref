---
message: "aggregate functions are not allowed in a recursive query's recursive term"
slug: aggregate-functions-are-not-allowed-in-a-recursive-query-s-recursive-term
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_RECURSION
    code: "42P19"
call_sites:
  - "postgres/src/backend/parser/parse_agg.c:1351"
reproduced: true
---

# `aggregate functions are not allowed in a recursive query's recursive term`

## What it means

The recursive term of a recursive common table expression used an aggregate function, which the SQL standard and Postgres forbid there.

## When it happens

It occurs in `WITH RECURSIVE` when the part after `UNION`/`UNION ALL` (the recursive term) contains an aggregate.

## How to fix

Remove the aggregate from the recursive term. Do the recursion without aggregation, then aggregate over the recursive CTE's result in an outer query. Aggregates and other constructs like `DISTINCT` are not allowed inside the recursive term itself.

## Example

*Reproduced* — captured from `reproducers/scenarios/44_functions_operators_aggregates.sql`.

```sql
WITH RECURSIVE t(n) AS (SELECT 1 UNION ALL SELECT count(*) FROM t) SELECT * FROM t;
```

Produces:

```text
ERROR:  aggregate functions are not allowed in a recursive query's recursive term
```

## Related

- [aggregate functions are not allowed in](./aggregate-functions-are-not-allowed-in.md)
- [aggregate function calls cannot contain set-returning function calls](./aggregate-function-calls-cannot-contain-set-returning-function-calls.md)
