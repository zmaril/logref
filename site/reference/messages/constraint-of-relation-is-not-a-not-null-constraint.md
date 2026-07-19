---
message: "constraint \"%s\" of relation \"%s\" is not a not-null constraint"
slug: constraint-of-relation-is-not-a-not-null-constraint
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:12411"
reproduced: false
---

# `constraint "%s" of relation "%s" is not a not-null constraint`

## What it means

A command that operates only on not-null constraints named a constraint of a different kind on the relation. The named constraint is not a not-null constraint.

## When it happens

It happens on operations that target not-null constraints by name when the constraint is actually a check, unique, or other kind.

## How to fix

Target a not-null constraint, or use the correct command for the constraint's type. Verify the constraint kind before referencing it.

## Example

*Illustrative* — a not-null operation on a non-not-null constraint.

```text
ERROR:  constraint "c" of relation "t" is not a not-null constraint
```

## Related

- [constraint of relation is not a foreign key constraint](./constraint-of-relation-is-not-a-foreign-key-constraint.md)
- [constraint is not a not-null constraint](./constraint-is-not-a-not-null-constraint.md)
