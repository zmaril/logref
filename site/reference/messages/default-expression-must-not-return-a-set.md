---
message: "DEFAULT expression must not return a set"
slug: default-expression-must-not-return-a-set
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:4896"
reproduced: false
---

# `DEFAULT expression must not return a set`

## What it means

A column `DEFAULT` expression evaluates to a set of rows rather than a single value. A default must produce exactly one scalar value for the column.

## When it happens

It fires from `CREATE TABLE` or `ALTER TABLE ... SET DEFAULT` when the default calls a set-returning function or otherwise yields multiple rows.

## How to fix

Make the default return a single value. Wrap a set-returning function in an aggregate or a scalar subquery (for example `(SELECT ... LIMIT 1)`), or pick a different expression. If you need multiple values, handle them in a trigger instead of a default.

## Example

*Illustrative* — a set-returning function as a default.

```sql
CREATE TABLE t (a int DEFAULT generate_series(1, 3));
-- DEFAULT expression must not return a set
```

## Related

- [DEFAULT expression must not contain column references](./default-expression-must-not-contain-column-references.md)
- [DEFAULT is not allowed in this context](./default-is-not-allowed-in-this-context.md)
