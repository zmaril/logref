---
message: "child column \"%s\" specifies generation expression"
slug: child-column-specifies-generation-expression
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_DEFINITION
    code: "42611"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:3151"
  - "postgres/src/backend/commands/tablecmds.c:3445"
reproduced: false
---

# `child column "%s" specifies generation expression`

## What it means

A child (inheriting or partition) table declared its own generation expression for a column that the parent also defines. The placeholder is the column name. A generated column's expression must come from a single place; a child cannot redefine it.

## When it happens

Creating a child table under a parent (via inheritance or partitioning) where the child's column definition includes `GENERATED ALWAYS AS (...)` for a column the parent already generates.

## How to fix

Remove the generation expression from the child's column definition and inherit it from the parent. Define the generation expression once, on the parent; children take it automatically.

## Example

*Illustrative* — a child redefining a generated column.

```text
ERROR:  child column "total" specifies generation expression
```

## Related

- [column inherits from generated column but specifies default](./column-inherits-from-generated-column-but-specifies-default.md)
- [cannot use generated column in partition key](./cannot-use-generated-column-in-partition-key.md)
