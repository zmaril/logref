---
message: "cannot rename inherited constraint \"%s\""
slug: cannot-rename-inherited-constraint
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:4215"
reproduced: false
---

# `cannot rename inherited constraint "%s"`

## What it means

An `ALTER TABLE ... RENAME CONSTRAINT` targeted a constraint that a child table inherited from a parent. Inherited constraints are named by the parent, so they cannot be renamed on the child alone. The placeholder is the constraint name.

## When it happens

It occurs when you rename an inherited constraint directly on a child table in an inheritance hierarchy.

## How to fix

Rename the constraint on the parent table so the change propagates to all children. Do not rename inherited constraints on individual children.

## Example

*Illustrative* — renaming an inherited constraint on a child.

```text
ERROR:  cannot rename inherited constraint "chk_positive"
```

## Related

- [cannot rename inherited column](./cannot-rename-inherited-column.md)
- [cannot mark inherited constraint as](./cannot-mark-inherited-constraint-as.md)
