---
message: "constraint must be altered in child tables too"
slug: constraint-must-be-altered-in-child-tables-too
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:12362"
reproduced: false
---

# `constraint must be altered in child tables too`

## What it means

An `ALTER TABLE ONLY` tried to change a constraint on a parent alone, but the constraint is inherited by children that would be left inconsistent. Inherited constraints must be altered across the whole hierarchy.

## When it happens

It happens on `ALTER TABLE ONLY parent ... CONSTRAINT ...` when the parent has children that inherit the constraint.

## How to fix

Run the `ALTER TABLE` without `ONLY` so the change reaches all children, or apply the change to each table in the hierarchy consistently.

## Example

*Illustrative* — ALTER ONLY on an inherited constraint.

```sql
ALTER TABLE ONLY parent ALTER CONSTRAINT c DEFERRABLE;
-- ERROR:  constraint must be altered in child tables too
```

## Related

- [constraint must be altered on child tables too](./constraint-must-be-altered-on-child-tables-too.md)
- [column must be added to child tables too](./column-must-be-added-to-child-tables-too.md)
