---
message: "column \"%s\" inherits conflicting generation expressions"
slug: column-inherits-conflicting-generation-expressions
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_DEFINITION
    code: "42611"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:3208"
reproduced: false
---

# `column "%s" inherits conflicting generation expressions`

## What it means

A generated column is inherited from more than one parent, and the parents define different generation expressions. There is no rule for merging two generation formulas, so the child cannot be created.

## When it happens

It occurs on `CREATE TABLE ... INHERITS` from multiple parents whose shared generated column uses different `GENERATED ALWAYS AS (...)` expressions.

## How to fix

Make the generation expression identical across the parents, or restructure the inheritance so only one parent supplies that generated column.

## Example

*Illustrative* — two parents with different generation expressions.

```sql
CREATE TABLE a (n int, g int GENERATED ALWAYS AS (n + 1) STORED);
CREATE TABLE b (n int, g int GENERATED ALWAYS AS (n * 2) STORED);
CREATE TABLE c () INHERITS (a, b);
-- ERROR:  column "g" inherits conflicting generation expressions
```

## Related

- [column inherits conflicting default values](./column-inherits-conflicting-default-values.md)
- [column in child table must be a generated column](./column-in-child-table-must-be-a-generated-column.md)
