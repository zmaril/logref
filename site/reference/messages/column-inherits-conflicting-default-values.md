---
message: "column \"%s\" inherits conflicting default values"
slug: column-inherits-conflicting-default-values
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_DEFINITION
    code: "42611"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:3214"
reproduced: false
---

# `column "%s" inherits conflicting default values`

## What it means

A column is inherited from more than one parent, and those parents supply different default values for it. Postgres cannot pick one default automatically, so the child definition is rejected.

## When it happens

It happens on `CREATE TABLE ... INHERITS` from multiple parents whose shared column carries different `DEFAULT` expressions.

## How to fix

Give the column an explicit default on the child table, which overrides the inherited ones, or make the parents agree on a single default before creating the child.

## Example

*Illustrative* — two parents with different defaults for the same column.

```sql
CREATE TABLE a (x int DEFAULT 1);
CREATE TABLE b (x int DEFAULT 2);
CREATE TABLE c () INHERITS (a, b);
-- ERROR:  column "x" inherits conflicting default values
-- HINT:  To resolve the conflict, specify a default explicitly.
```

## Related

- [column inherits conflicting generation expressions](./column-inherits-conflicting-generation-expressions.md)
- [column has a type conflict](./column-has-a-type-conflict.md)
