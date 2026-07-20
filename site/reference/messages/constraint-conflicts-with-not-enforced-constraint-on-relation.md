---
message: "constraint \"%s\" conflicts with NOT ENFORCED constraint on relation \"%s\""
slug: constraint-conflicts-with-not-enforced-constraint-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/catalog/heap.c:2838"
reproduced: false
---

# `constraint "%s" conflicts with NOT ENFORCED constraint on relation "%s"`

## What it means

A constraint being added conflicts with a same-named `NOT ENFORCED` constraint already on the relation. Their differing enforcement status makes them incompatible under one name.

## When it happens

It happens on `ALTER TABLE ... ADD CONSTRAINT` (or inheritance) when the relation already has a `NOT ENFORCED` constraint with a conflicting name.

## How to fix

Match the enforcement status or rename one constraint. Make the existing constraint enforced, drop it, or give the new one a different name so they do not collide.

## Example

*Illustrative* — an enforced constraint vs an existing NOT ENFORCED one.

```text
ERROR:  constraint "chk" conflicts with NOT ENFORCED constraint on relation "t"
```

## Related

- [constraint conflicts with NOT ENFORCED constraint on child table](./constraint-conflicts-with-not-enforced-constraint-on-child-table.md)
- [constraint conflicts with NOT VALID constraint on relation](./constraint-conflicts-with-not-valid-constraint-on-relation.md)
