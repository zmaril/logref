---
message: "constraint must be added to child tables too"
slug: constraint-must-be-added-to-child-tables-too
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8163"
  - "postgres/src/backend/commands/tablecmds.c:10157"
reproduced: false
---

# `constraint must be added to child tables too`

## What it means

An `ALTER TABLE ... ADD CONSTRAINT ... ONLY` on a parent table could not apply because the constraint must also exist on the children, and `ONLY` prevents adding it to them. The constraint cannot be limited to the parent alone in this case.

## When it happens

Adding a constraint with `ONLY` to an inheritance parent or partitioned table where the constraint semantics require every child to carry it as well.

## How to fix

Add the constraint without `ONLY` so it propagates to the children, or add matching constraints to each child first. For inheritance hierarchies, the constraint has to exist consistently across parent and children.

## Example

*Illustrative* — ONLY on a constraint that must reach children.

```sql
ALTER TABLE ONLY parent ADD CONSTRAINT c CHECK (x > 0);
-- ERROR:  constraint must be added to child tables too
```

## Related

- [constraint must be validated on child tables too](./constraint-must-be-validated-on-child-tables-too.md)
- [cannot change NO INHERIT status of not-null constraint on relation](./cannot-change-no-inherit-status-of-not-null-constraint-on-relation.md)
