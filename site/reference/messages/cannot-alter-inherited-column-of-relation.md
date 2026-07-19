---
message: "cannot alter inherited column \"%s\" of relation \"%s\""
slug: cannot-alter-inherited-column-of-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:15152"
reproduced: false
---

# `cannot alter inherited column "%s" of relation "%s"`

## What it means

An `ALTER TABLE` tried to change a column that the named relation inherits from a parent. The placeholders name the column and relation. The column is defined on the parent and cannot be altered on this relation directly.

## When it happens

It occurs when altering an inherited column on a child table or partition, identified together with its relation.

## How to fix

Make the change on the parent table so it propagates to the children. Inherited columns are controlled by the parent to keep the hierarchy consistent.

## Example

*Illustrative* — altering an inherited column, named with its relation.

```text
ERROR:  cannot alter inherited column "a" of relation "child"
```

## Related

- [cannot alter inherited column](./cannot-alter-inherited-column.md)
- [cannot alter inherited constraint on relation](./cannot-alter-inherited-constraint-on-relation.md)
