---
message: "subquery must return only one column"
slug: subquery-must-return-only-one-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:1944"
  - "postgres/src/backend/parser/parse_expr.c:3848"
reproduced: true
---

# `subquery must return only one column`

## What it means

A scalar subquery (one used where a single value is expected) returned more than one column. In such positions a subquery must produce exactly one column.

## When it happens

It arises when a subquery in an expression, `IN`/comparison against a single value, or another scalar context selects multiple columns — for example `WHERE x = (SELECT a, b FROM ...)`.

## How to fix

Select a single column in the subquery. If you need to compare against multiple columns, use a row constructor and a row-comparison, or restructure with a join. For `IN`, the subquery should return one column matching the left-hand value.

## Example

*Reproduced* — captured from `reproducers/scenarios/23_query_semantics_extended.sql`.

```sql
SELECT (SELECT id, label FROM repro.parent LIMIT 1);
```

Produces:

```text
ERROR:  subquery must return only one column
```

## Related

- [subquery is bogus](./subquery-is-bogus.md)
- [too many column names were specified](./too-many-column-names-were-specified.md)
