---
message: "%s cannot be applied to a function"
slug: cannot-be-applied-to-a-function
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/analyze.c:3961"
reproduced: false
---

# `%s cannot be applied to a function`

## What it means

A locking clause such as `FOR UPDATE` or `FOR SHARE` was applied to a set-returning function in the query's `FROM` list. Row-level locking clauses only apply to real tables, since a function's output rows are not stored rows that can be locked.

## When it happens

It occurs when a `SELECT ... FOR UPDATE`/`FOR SHARE` names a function-in-`FROM` (a `FROM func(...)` item) among its locked relations.

## How to fix

Remove the function from the locking clause, or list only the base tables you truly need to lock in `OF table_name`. Materialize the function result into a table first if its rows must be locked.

## Example

*Illustrative* — locking a function result.

```sql
SELECT * FROM generate_series(1,5) FOR UPDATE;
```

## Related

- [cannot be applied to a join](./cannot-be-applied-to-a-join.md)
- [cannot be applied to a table function](./cannot-be-applied-to-a-table-function.md)
