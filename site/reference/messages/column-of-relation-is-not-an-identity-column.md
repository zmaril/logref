---
message: "column \"%s\" of relation \"%s\" is not an identity column"
slug: column-of-relation-is-not-an-identity-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8577"
  - "postgres/src/backend/commands/tablecmds.c:8673"
reproduced: false
---

# `column "%s" of relation "%s" is not an identity column`

## What it means

A command that only applies to identity columns (such as `ALTER COLUMN ... DROP IDENTITY` or `RESTART`) named a column that is not an identity column. The placeholders are the column and the relation. The operation does not apply to an ordinary column.

## When it happens

Running `ALTER TABLE ... ALTER COLUMN ... DROP IDENTITY`/`RESTART` against a column that was never defined `GENERATED ... AS IDENTITY`.

## How to fix

Target a column that is actually an identity column, or use `IF EXISTS` where supported to make the drop tolerant. Check `\d table` or `pg_attribute.attidentity` to confirm which columns are identity columns.

## Example

*Illustrative* — dropping identity from a plain column.

```sql
ALTER TABLE t ALTER COLUMN name DROP IDENTITY;
-- ERROR:  column "name" of relation "t" is not an identity column
```

## Related

- [column of relation is not a generated column](./column-of-relation-is-not-a-generated-column.md)
- [column can only be updated to DEFAULT](./column-can-only-be-updated-to-default.md)
