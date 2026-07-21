---
message: "collation of DEFAULT expression conflicts with RETURNING clause"
slug: collation-of-default-expression-conflicts-with-returning-clause
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_COLLATION_MISMATCH
    code: "42P21"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:4911"
reproduced: false
---

# `collation of DEFAULT expression conflicts with RETURNING clause`

## What it means

A statement's `DEFAULT` expression and its `RETURNING` clause implied different collations for the same value. The two collations conflict, so the server cannot resolve which to use.

## When it happens

It occurs on an `INSERT` or `UPDATE` with a `RETURNING` clause where a defaulted column's collation differs from the collation the returning expression expects.

## How to fix

Give the value one consistent collation with an explicit `COLLATE` clause, or align the column and expression collations so they agree. Remove the conflicting implicit collation.

## Example

*Illustrative* — default and returning collations conflicting.

```text
ERROR:  collation of DEFAULT expression conflicts with RETURNING clause
```

## Related

- [collation mismatch between explicit collations and](./collation-mismatch-between-explicit-collations-and.md)
- [column has a collation conflict](./column-has-a-collation-conflict.md)
