---
message: "ALTER TABLE / DROP EXPRESSION is not supported for virtual generated columns"
slug: alter-table-drop-expression-is-not-supported-for-virtual-generated-columns
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8970"
reproduced: false
---

# `ALTER TABLE / DROP EXPRESSION is not supported for virtual generated columns`

## What it means

An `ALTER TABLE ... ALTER COLUMN ... DROP EXPRESSION` targeted a virtual generated column, but dropping the generation expression is not supported for virtual (non-stored) generated columns.

## When it happens

It occurs when trying to convert a virtual generated column into an ordinary column by dropping its expression.

## How to fix

You cannot drop the expression of a virtual generated column in place. Drop and re-add the column as a plain column if you need it to become non-generated, adjusting dependent objects accordingly. `DROP EXPRESSION` applies to stored generated columns.

## Example

*Illustrative* — dropping the expression of a virtual generated column.

```sql
ALTER TABLE t ALTER COLUMN g DROP EXPRESSION;  -- g is a virtual generated column
```

## Related

- [alter table / set expression is not supported for virtual generated columns in a publication](./alter-table-set-expression-is-not-supported-for-virtual-generated-columns-in.md)
- [alter table / drop expression must be applied to child tables too](./alter-table-drop-expression-must-be-applied-to-child-tables-too.md)
