---
message: "cannot alter inherited constraint \"%s\" on relation \"%s\""
slug: cannot-alter-inherited-constraint-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:12425"
reproduced: false
---

# `cannot alter inherited constraint "%s" on relation "%s"`

## What it means

An `ALTER TABLE ... ALTER CONSTRAINT` targeted a constraint that the relation inherits from a parent. The placeholders name the constraint and relation. Inherited constraints are altered on the parent, not on the child.

## When it happens

It occurs when altering a constraint on a child table or partition that was inherited from the partitioned or parent table.

## How to fix

Alter the constraint on the parent table, which applies the change through the hierarchy. Inherited constraints cannot be altered on a child independently.

## Example

*Illustrative* — altering an inherited constraint on a child.

```text
ERROR:  cannot alter inherited constraint "c" on relation "child"
```

## Related

- [cannot alter inherited column of relation](./cannot-alter-inherited-column-of-relation.md)
- [cannot alter constraint on relation](./cannot-alter-constraint-on-relation.md)
