---
message: "%s cannot be applied to a join"
slug: cannot-be-applied-to-a-join
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/analyze.c:3952"
reproduced: false
---

# `%s cannot be applied to a join`

## What it means

A locking clause such as `FOR UPDATE` was applied to a join rather than a base table. Row-level locking targets individual tables, and a join is a computed result, not a lockable relation.

## When it happens

It occurs when a `SELECT ... FOR UPDATE`/`FOR SHARE` names a joined result — for example the alias of a subquery join — in its lock list.

## How to fix

Name the underlying base tables in `OF table_name`, not the join. Lock the specific tables whose rows you need, and leave the join itself out of the locking clause.

## Example

*Illustrative* — locking a join.

```sql
SELECT * FROM a JOIN b USING (id) FOR UPDATE OF a;
```

## Related

- [cannot be applied to the nullable side of an outer join](./cannot-be-applied-to-the-nullable-side-of-an-outer-join.md)
- [cannot be applied to a function](./cannot-be-applied-to-a-function.md)
