---
message: "aggregate function calls cannot be nested"
slug: aggregate-function-calls-cannot-be-nested
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_GROUPING_ERROR
    code: "42803"
call_sites:
  - "postgres/src/backend/executor/nodeAgg.c:4057"
  - "postgres/src/backend/parser/parse_agg.c:706"
  - "postgres/src/backend/parser/parse_agg.c:749"
reproduced: true
---

# `aggregate function calls cannot be nested`

## What it means

An aggregate function was written with another aggregate inside its arguments, such as `sum(avg(x))`. Aggregates collapse a set of rows to one value; nesting one directly inside another is undefined at a single query level, so it is rejected.

## When it happens

Writing `max(count(*))`, `sum(avg(col))`, or similar in one `SELECT`, usually when you meant to aggregate over the result of a prior aggregation.

## How to fix

Aggregate in two stages: compute the inner aggregate in a subquery or CTE, then apply the outer aggregate to its output. For example `SELECT max(c) FROM (SELECT count(*) c FROM t GROUP BY k) s`. Window functions can also express `aggregate-of-aggregate` patterns without nesting.

## Example

*Reproduced* — captured from `reproducers/scenarios/44_functions_operators_aggregates.sql`.

```sql
SELECT percentile_cont(avg(id)) WITHIN GROUP (ORDER BY id) FROM repro.parent;
```

Produces:

```text
ERROR:  aggregate function calls cannot be nested
```

## Related

- [aggregate function called in non-aggregate context](./aggregate-function-called-in-non-aggregate-context.md)
- [cannot determine result data type](./cannot-determine-result-data-type.md)
