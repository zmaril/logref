---
message: "column \"%s\" of relation \"%s\" must be declared NOT NULL before identity can be added"
slug: column-of-relation-must-be-declared-not-null-before-identity-can-be-added
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8428"
reproduced: false
---

# `column "%s" of relation "%s" must be declared NOT NULL before identity can be added`

## What it means

Adding an identity to a column requires the column to be `NOT NULL` first, and the target column allows nulls. Identity columns generate non-null values, so the column must reject nulls.

## When it happens

It happens on `ALTER TABLE ... ALTER COLUMN ... ADD GENERATED ... AS IDENTITY` when the column is not yet marked `NOT NULL`.

## How to fix

Mark the column `NOT NULL` first with `ALTER TABLE ... ALTER COLUMN ... SET NOT NULL`, then add the identity. Ensure any existing rows already have non-null values in that column.

## Example

*Illustrative* — adding identity to a nullable column.

```sql
ALTER TABLE t ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY;
-- ERROR:  column "id" of relation "t" must be declared NOT NULL before identity can be added
```

## Related

- [column of relation is already an identity column](./column-of-relation-is-already-an-identity-column.md)
- [column of table is not marked NOT NULL](./column-of-table-is-not-marked-not-null.md)
