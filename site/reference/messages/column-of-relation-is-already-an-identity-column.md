---
message: "column \"%s\" of relation \"%s\" is already an identity column"
slug: column-of-relation-is-already-an-identity-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8459"
reproduced: false
---

# `column "%s" of relation "%s" is already an identity column`

## What it means

An `ALTER TABLE ... ALTER COLUMN ... ADD GENERATED ... AS IDENTITY` was run against a column that is already an identity column. A column can be identity only once.

## When it happens

It happens when identity is added to a column that already has an identity definition.

## How to fix

Use `ALTER TABLE ... ALTER COLUMN ... SET GENERATED { ALWAYS | BY DEFAULT }` to change an existing identity's behavior, or drop the identity first with `DROP IDENTITY` before adding a new one.

## Example

*Illustrative* — adding identity twice.

```sql
ALTER TABLE t ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY;
-- ERROR:  column "id" of relation "t" is already an identity column
```

## Related

- [column of relation already has a default value](./column-of-relation-already-has-a-default-value.md)
- [column of relation must be declared NOT NULL before identity can be added](./column-of-relation-must-be-declared-not-null-before-identity-can-be-added.md)
