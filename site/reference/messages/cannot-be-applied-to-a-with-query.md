---
message: "%s cannot be applied to a WITH query"
slug: cannot-be-applied-to-a-with-query
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/analyze.c:3988"
reproduced: false
---

# `%s cannot be applied to a WITH query`

## What it means

A locking clause such as `FOR UPDATE` named a `WITH` (common table expression) result. A CTE is a computed subquery, not a base table, so its rows cannot be locked directly.

## When it happens

It occurs when a `SELECT ... FOR UPDATE`/`FOR SHARE` lists the name of a CTE among its locked relations.

## How to fix

Move the locking clause into the CTE's own query so it locks the base tables there, or lock the underlying tables in the outer query. A CTE name is not a lockable relation.

## Example

*Illustrative* — locking a CTE.

```sql
WITH c AS (SELECT * FROM t) SELECT * FROM c FOR UPDATE;
```

## Related

- [cannot be applied to a named tuplestore](./cannot-be-applied-to-a-named-tuplestore.md)
- [cannot be applied to a join](./cannot-be-applied-to-a-join.md)
