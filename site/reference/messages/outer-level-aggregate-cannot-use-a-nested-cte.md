---
message: "outer-level aggregate cannot use a nested CTE"
slug: outer-level-aggregate-cannot-use-a-nested-cte
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/parse_agg.c:719"
  - "postgres/src/backend/parser/parse_agg.c:756"
reproduced: false
---

# `outer-level aggregate cannot use a nested CTE`

## What it means

An aggregate that belongs to an outer query level was written so that its argument references a CTE (`WITH` query) defined at an inner level. That combination is not supported, because the aggregate would have to reach into a scope it does not own.

## When it happens

It arises with correlated subqueries where an aggregate call at the outer level pulls in a name that resolves to a nested `WITH` definition.

## How to fix

Restructure the query so the aggregate's argument refers only to columns available at the aggregate's own level. Moving the CTE to the outer level, or replacing it with a join or a subselect that exposes the needed column, avoids the restriction.

## Example

*Illustrative* — an outer aggregate referencing an inner CTE.

```text
ERROR:  outer-level aggregate cannot use a nested CTE
```

## Related

- [ordered-set aggregate called in non-aggregate context](./ordered-set-aggregate-called-in-non-aggregate-context.md)
- [subquery must return only one column](./subquery-must-return-only-one-column.md)
