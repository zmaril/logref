---
message: "can only specify a constant, non-aggregate function, or operator expression for DEFAULT"
slug: can-only-specify-a-constant-non-aggregate-function-or-operator-expression-for
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:4886"
reproduced: false
---

# `can only specify a constant, non-aggregate function, or operator expression for DEFAULT`

## What it means

A column `DEFAULT` expression referenced something a default may not use — a variable column, an aggregate, a subquery, or another disallowed construct. A default must be a constant or an expression that does not depend on other columns or query results. The message ends at the word DEFAULT.

## When it happens

It occurs in `CREATE TABLE` or `ALTER TABLE ... SET DEFAULT` when the default expression contains an aggregate, a reference to another column, a subquery, or a similar non-constant term.

## How to fix

Rewrite the default as a constant or a self-contained expression, for example `now()` or `nextval('seq')`. To derive a value from other columns, use a generated column; to compute across rows, populate the value in a trigger or the inserting statement instead of a default.

## Example

*Illustrative* — a disallowed default expression.

```sql
CREATE TABLE t (a int, b int DEFAULT (SELECT max(x) FROM other));
```

## Related

- [both default and generation expression specified for column of table](./both-default-and-generation-expression-specified-for-column-of-table.md)
- [cannot add nan to pg_lsn](./cannot-add-nan-to-pg-lsn.md)
