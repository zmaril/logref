---
message: "column \"%s\" of relation \"%s\" already has a default value"
slug: column-of-relation-already-has-a-default-value
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8465"
reproduced: false
---

# `column "%s" of relation "%s" already has a default value`

## What it means

An operation tried to set a default on a column that already has one, in a context that does not allow replacing it. The existing default is in the way.

## When it happens

It happens in certain `ALTER TABLE` paths (for example adding an identity or a generated default) when the column already carries a `DEFAULT` expression.

## How to fix

Drop the existing default first with `ALTER TABLE ... ALTER COLUMN ... DROP DEFAULT`, then apply the new one. Confirm which default the column currently has before changing it.

## Example

*Illustrative* — adding identity to a column that already has a default.

```sql
ALTER TABLE t ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY;
-- ERROR:  column "id" of relation "t" already has a default value
```

## Related

- [column of relation is already an identity column](./column-of-relation-is-already-an-identity-column.md)
- [column of relation already exists](./column-of-relation-already-exists.md)
