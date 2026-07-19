---
message: "DEFAULT expression must not contain column references"
slug: default-expression-must-not-contain-column-references
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/parser/parse_expr.c:4891"
reproduced: false
---

# `DEFAULT expression must not contain column references`

## What it means

A column `DEFAULT` expression referred to a column. Defaults are computed without a row in hand, so they may not read other columns of the table. The default must depend only on constants, functions, and similar column-free expressions.

## When it happens

It fires from `CREATE TABLE` or `ALTER TABLE ... SET DEFAULT` when the default expression names a column of the table.

## How to fix

Remove the column reference from the default. If the value must derive from other columns, use a generated column (`GENERATED ALWAYS AS (...) STORED`) or compute it in a `BEFORE INSERT` trigger, both of which run with the row available.

## Example

*Illustrative* — a default that reads another column.

```sql
CREATE TABLE t (a int, b int DEFAULT a + 1);
-- DEFAULT expression must not contain column references
```

## Related

- [DEFAULT expression must not return a set](./default-expression-must-not-return-a-set.md)
- [DEFAULT is not allowed in this context](./default-is-not-allowed-in-this-context.md)
