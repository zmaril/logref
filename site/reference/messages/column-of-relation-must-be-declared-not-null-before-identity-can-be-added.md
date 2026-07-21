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
reproduced: true
---

# `column "%s" of relation "%s" must be declared NOT NULL before identity can be added`

## What it means

Adding an identity to a column requires the column to be `NOT NULL` first, and the target column allows nulls. Identity columns generate non-null values, so the column must reject nulls.

## When it happens

It happens on `ALTER TABLE ... ALTER COLUMN ... ADD GENERATED ... AS IDENTITY` when the column is not yet marked `NOT NULL`.

## How to fix

Mark the column `NOT NULL` first with `ALTER TABLE ... ALTER COLUMN ... SET NOT NULL`, then add the identity. Ensure any existing rows already have non-null values in that column.

## Example

*Reproduced* — captured from `reproducers/scenarios/36_constraints_partitioning.sql`.

```sql
ALTER TABLE s36.idt ALTER COLUMN b ADD GENERATED ALWAYS AS IDENTITY;
```

Produces:

```text
ERROR:  column "b" of relation "idt" must be declared NOT NULL before identity can be added
```

## Related

- [column of relation is already an identity column](./column-of-relation-is-already-an-identity-column.md)
- [column of table is not marked NOT NULL](./column-of-table-is-not-marked-not-null.md)
