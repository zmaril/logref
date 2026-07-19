---
message: "column \"%s\" inherits from generated column but specifies identity"
slug: column-inherits-from-generated-column-but-specifies-identity
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_DEFINITION
    code: "42611"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:3143"
  - "postgres/src/backend/commands/tablecmds.c:3437"
reproduced: false
---

# `column "%s" inherits from generated column but specifies identity`

## What it means

A child table's column inherits a generated column from its parent but also declares an identity (`GENERATED ... AS IDENTITY`). The placeholder is the column name. A column cannot be both a computed generated column and an identity column.

## When it happens

Defining an inheritance child or partition whose column is a generated column in the parent while the child's definition adds an identity specification for it.

## How to fix

Remove the identity clause from the child's column definition. The column is already generated in the parent; it inherits that behavior and cannot simultaneously be an identity column.

## Example

*Illustrative* — an identity clause on an inherited generated column.

```text
ERROR:  column "total" inherits from generated column but specifies identity
```

## Related

- [column inherits from generated column but specifies default](./column-inherits-from-generated-column-but-specifies-default.md)
- [child column specifies generation expression](./child-column-specifies-generation-expression.md)
