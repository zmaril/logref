---
message: "constraint \"%s\" conflicts with non-inherited constraint on relation \"%s\""
slug: constraint-conflicts-with-non-inherited-constraint-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/catalog/heap.c:2805"
reproduced: false
---

# `constraint "%s" conflicts with non-inherited constraint on relation "%s"`

## What it means

A constraint being added or inherited conflicts with a non-inherited (locally-defined) constraint of the same name already on the relation. The local constraint blocks the new one.

## When it happens

It happens on `CREATE TABLE ... INHERITS` or `ALTER TABLE ... ADD CONSTRAINT` when the relation already has its own constraint that conflicts.

## How to fix

Rename or remove the existing local constraint, or give the new constraint a different name, so they no longer conflict. Check the relation's current constraints.

## Example

*Illustrative* — a new constraint clashing with a local one.

```text
ERROR:  constraint "chk" conflicts with non-inherited constraint on relation "t"
```

## Related

- [constraint conflicts with non-inherited constraint on child table](./constraint-conflicts-with-non-inherited-constraint-on-child-table.md)
- [constraint conflicts with inherited constraint on relation](./constraint-conflicts-with-inherited-constraint-on-relation.md)
