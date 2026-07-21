---
message: "more than one row returned by a subquery used as an expression"
slug: more-than-one-row-returned-by-a-subquery-used-as-an-expression
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_CARDINALITY_VIOLATION
    code: "21000"
call_sites:
  - "postgres/src/backend/executor/nodeSubplan.c:293"
  - "postgres/src/backend/executor/nodeSubplan.c:319"
  - "postgres/src/backend/executor/nodeSubplan.c:373"
  - "postgres/src/backend/executor/nodeSubplan.c:1198"
reproduced: false
---

# `more than one row returned by a subquery used as an expression`

## What it means

A scalar subquery — one written where a single value is expected, such as in a `SELECT` list, a `WHERE` comparison, or an assignment — returned more than one row. A scalar subquery must yield at most one row; returning several is ambiguous, so it is rejected rather than picking one arbitrarily.

## When it happens

A subquery like `(SELECT col FROM t WHERE ...)` used as a value matches multiple rows because its filter is not as selective as assumed, a join key is not unique, or a correlated condition is missing.

## How to fix

Make the subquery return one row: tighten its `WHERE`, add the missing correlation, or aggregate (`max`, `min`, `array_agg`) so it collapses to a single value. If several matches are legitimate and you want any one, add `LIMIT 1` with an `ORDER BY` that makes the choice deterministic. If you meant a set membership test, use `IN (subquery)` instead of an equality against a scalar subquery.

## Example

*Illustrative* — a scalar subquery matching two rows.

```sql
SELECT (SELECT id FROM users WHERE active);  -- more than one active user
```

## Related

- [cannot determine result data type](./cannot-determine-result-data-type.md)
- [command cannot affect row a second time](./command-cannot-affect-row-a-second-time.md)
