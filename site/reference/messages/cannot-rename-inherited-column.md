---
message: "cannot rename inherited column \"%s\""
slug: cannot-rename-inherited-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:4053"
reproduced: false
---

# `cannot rename inherited column "%s"`

## What it means

An `ALTER TABLE ... RENAME COLUMN` targeted a column that a child table inherited from a parent. Inherited columns are named by the parent, so they cannot be renamed on the child alone. The placeholder is the column name.

## When it happens

It occurs when you rename an inherited column directly on a child table in an inheritance hierarchy.

## How to fix

Rename the column on the parent table so the change propagates to all children. Do not rename inherited columns on individual children.

## Example

*Illustrative* — renaming an inherited column on a child.

```text
ERROR:  cannot rename inherited column "id"
```

## Related

- [cannot rename inherited constraint](./cannot-rename-inherited-constraint.md)
- [cannot rename column of typed table](./cannot-rename-column-of-typed-table.md)
