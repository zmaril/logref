---
message: "column \"%s\" of relation \"%s\" is not a generated column"
slug: column-of-relation-is-not-a-generated-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8775"
  - "postgres/src/backend/commands/tablecmds.c:8979"
reproduced: false
---

# `column "%s" of relation "%s" is not a generated column`

## What it means

A command that only applies to generated columns (such as `ALTER COLUMN ... DROP EXPRESSION`) named a column that is not generated. The placeholders are the column and the relation. The operation has no meaning for an ordinary column.

## When it happens

Running `ALTER TABLE ... ALTER COLUMN ... DROP EXPRESSION` or a similar generated-column-specific command against a column that has no generation expression.

## How to fix

Target a column that is actually `GENERATED ALWAYS AS (...) STORED`, or drop the operation if the column is ordinary. Check the column's definition (`\d table` or `pg_attribute.attgenerated`) before issuing the command.

## Example

*Illustrative* — dropping an expression from a non-generated column.

```sql
ALTER TABLE t ALTER COLUMN name DROP EXPRESSION;
-- ERROR:  column "name" of relation "t" is not a generated column
```

## Related

- [column of relation is not an identity column](./column-of-relation-is-not-an-identity-column.md)
- [cannot use generated column in partition key](./cannot-use-generated-column-in-partition-key.md)
