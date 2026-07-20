---
message: "column \"%s\" inherits from generated column but specifies default"
slug: column-inherits-from-generated-column-but-specifies-default
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_DEFINITION
    code: "42611"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:3138"
  - "postgres/src/backend/commands/tablecmds.c:3432"
reproduced: false
---

# `column "%s" inherits from generated column but specifies default`

## What it means

A child table's column inherits a generated column from its parent but also declares a `DEFAULT`. The placeholder is the column name. A generated column derives its value from an expression and cannot also carry a default, so the two are incompatible.

## When it happens

Defining an inheritance child or partition whose column is generated in the parent while the child's definition adds a `DEFAULT` clause for it.

## How to fix

Remove the `DEFAULT` from the child's column definition; a generated column takes its value from the parent's generation expression, not a default. Let the column inherit cleanly.

## Example

*Illustrative* — a default on an inherited generated column.

```text
ERROR:  column "total" inherits from generated column but specifies default
```

## Related

- [column inherits from generated column but specifies identity](./column-inherits-from-generated-column-but-specifies-identity.md)
- [child column specifies generation expression](./child-column-specifies-generation-expression.md)
