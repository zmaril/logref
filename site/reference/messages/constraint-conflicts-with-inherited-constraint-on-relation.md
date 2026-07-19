---
message: "constraint \"%s\" conflicts with inherited constraint on relation \"%s\""
slug: constraint-conflicts-with-inherited-constraint-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/catalog/heap.c:2816"
reproduced: false
---

# `constraint "%s" conflicts with inherited constraint on relation "%s"`

## What it means

A constraint being added to a relation conflicts with a constraint the relation inherits from a parent. The new constraint cannot coexist with the inherited one under the same name or definition.

## When it happens

It happens on `CREATE TABLE ... INHERITS` or `ALTER TABLE ... ADD CONSTRAINT` when the added constraint clashes with one inherited from a parent.

## How to fix

Rename the new constraint, adjust it so it does not conflict, or rely on the inherited constraint instead of adding a duplicate. Review the parent's constraints to see what is inherited.

## Example

*Illustrative* — a constraint clashing with an inherited one.

```text
ERROR:  constraint "chk" conflicts with inherited constraint on relation "child"
```

## Related

- [constraint conflicts with non-inherited constraint on relation](./constraint-conflicts-with-non-inherited-constraint-on-relation.md)
- [constraint conflicts with NOT ENFORCED constraint on relation](./constraint-conflicts-with-not-enforced-constraint-on-relation.md)
