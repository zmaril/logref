---
message: "cannot drop generation expression from inherited column"
slug: cannot-drop-generation-expression-from-inherited-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8927"
reproduced: false
---

# `cannot drop generation expression from inherited column`

## What it means

An `ALTER TABLE ... ALTER COLUMN ... DROP EXPRESSION` targeted a generated column that a child inherits from a parent. The generation expression is defined on the parent, so it cannot be dropped from the inherited copy on the child.

## When it happens

It occurs when running `DROP EXPRESSION` on a generated column of a child table that inherits it from a parent.

## How to fix

Drop the generation expression on the parent table, which propagates to children, rather than on the inherited column. Manage generated-column definitions at the level where they were declared.

## Example

*Illustrative* — dropping an inherited generation expression.

```text
ERROR:  cannot drop generation expression from inherited column
```

## Related

- [cannot drop inherited column](./cannot-drop-inherited-column.md)
- [cannot drop inherited constraint of relation](./cannot-drop-inherited-constraint-of-relation.md)
