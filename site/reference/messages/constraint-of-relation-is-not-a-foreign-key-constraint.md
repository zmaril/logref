---
message: "constraint \"%s\" of relation \"%s\" is not a foreign key constraint"
slug: constraint-of-relation-is-not-a-foreign-key-constraint
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:12398"
reproduced: false
---

# `constraint "%s" of relation "%s" is not a foreign key constraint`

## What it means

A command that operates only on foreign keys named a constraint of a different kind on the relation. The named constraint is not a foreign key, so the operation cannot apply.

## When it happens

It happens on `ALTER TABLE ... ALTER CONSTRAINT` (adjusting deferrability) or similar FK-only operations when the constraint is, say, a check or unique constraint.

## How to fix

Target a foreign-key constraint, or use the correct command for the constraint's type. Check the constraint kind with `\d table`.

## Example

*Illustrative* — an FK operation on a non-FK constraint.

```text
ERROR:  constraint "c" of relation "t" is not a foreign key constraint
```

## Related

- [constraint of relation is not a not-null constraint](./constraint-of-relation-is-not-a-not-null-constraint.md)
- [constraint is not a foreign key constraint](./constraint-is-not-a-foreign-key-constraint.md)
