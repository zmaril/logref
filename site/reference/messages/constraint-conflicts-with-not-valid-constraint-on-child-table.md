---
message: "constraint \"%s\" conflicts with NOT VALID constraint on child table \"%s\""
slug: constraint-conflicts-with-not-valid-constraint-on-child-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:18456"
reproduced: false
---

# `constraint "%s" conflicts with NOT VALID constraint on child table "%s"`

## What it means

A constraint being propagated to a child table conflicts with a same-named `NOT VALID` constraint already present on the child. Their differing validity status makes them incompatible under one name.

## When it happens

It happens when adding a constraint to a parent that would propagate to a child which already has a same-named `NOT VALID` constraint.

## How to fix

Validate or drop the child's `NOT VALID` constraint, or rename one of the two, so the names and states do not collide. Review the child's constraints before propagating from the parent.

## Example

*Illustrative* — a validated parent constraint vs a NOT VALID child one.

```text
ERROR:  constraint "chk" conflicts with NOT VALID constraint on child table "child"
```

## Related

- [constraint conflicts with NOT VALID constraint on relation](./constraint-conflicts-with-not-valid-constraint-on-relation.md)
- [constraint conflicts with NOT ENFORCED constraint on child table](./constraint-conflicts-with-not-enforced-constraint-on-child-table.md)
