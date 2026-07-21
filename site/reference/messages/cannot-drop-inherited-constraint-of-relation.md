---
message: "cannot drop inherited constraint \"%s\" of relation \"%s\""
slug: cannot-drop-inherited-constraint-of-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:14641"
reproduced: false
---

# `cannot drop inherited constraint "%s" of relation "%s"`

## What it means

An `ALTER TABLE ... DROP CONSTRAINT` named a constraint that the relation inherits from a parent. Inherited constraints are defined on the parent, so they cannot be dropped from the child on its own. The placeholders are the constraint and relation names.

## When it happens

It occurs when dropping an inherited constraint on a child table rather than on the parent that defines it.

## How to fix

Drop the constraint on the parent, which removes it from all children, or detach the child from inheritance first. Constraint changes propagate from the parent.

## Example

*Illustrative* — dropping an inherited constraint.

```text
ERROR:  cannot drop inherited constraint "c" of relation "t"
```

## Related

- [cannot drop inherited column](./cannot-drop-inherited-column.md)
- [cannot drop generation expression from inherited column](./cannot-drop-generation-expression-from-inherited-column.md)
