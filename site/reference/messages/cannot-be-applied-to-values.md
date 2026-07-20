---
message: "%s cannot be applied to VALUES"
slug: cannot-be-applied-to-values
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/parser/analyze.c:2086"
  - "postgres/src/backend/parser/analyze.c:3979"
reproduced: false
---

# `%s cannot be applied to VALUES`

## What it means

A clause that cannot attach to a bare `VALUES` list was used with one. The placeholder names the clause. A standalone `VALUES` expression does not support constructs such as `FOR UPDATE` or certain `WITH` interactions that require a real query target.

## When it happens

Writing something like `VALUES (...) FOR UPDATE`, or applying a locking or other clause to a `VALUES` construct that is not backed by a table.

## How to fix

Wrap the `VALUES` in a subquery that selects from a real relation if you need the clause, or drop the clause. A bare `VALUES` list has no rows to lock or otherwise act on in the way the clause expects.

## Example

*Illustrative* — locking a VALUES list.

```sql
VALUES (1),(2) FOR UPDATE;
-- ERROR:  SELECT FOR UPDATE/SHARE cannot be applied to VALUES
```

## Related

- [cannot be specified multiple times](./cannot-be-specified-multiple-times.md)
- [cannot use type in RETURNING clause of](./cannot-use-type-in-returning-clause-of.md)
