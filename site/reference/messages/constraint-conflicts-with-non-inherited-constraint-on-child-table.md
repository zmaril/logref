---
message: "constraint \"%s\" conflicts with non-inherited constraint on child table \"%s\""
slug: constraint-conflicts-with-non-inherited-constraint-on-child-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:18445"
reproduced: false
---

# `constraint "%s" conflicts with non-inherited constraint on child table "%s"`

## What it means

A constraint being propagated to a child table conflicts with a non-inherited constraint that the child already has of the same name. The child's own constraint stands in the way of the inherited one.

## When it happens

It happens when adding a constraint to a parent (which should propagate to children) and a child already has a locally-defined constraint with a conflicting name or definition.

## How to fix

Rename or drop the conflicting child-local constraint, or choose a different name for the parent constraint, so the two do not collide. Inspect the child's constraints before propagating.

## Example

*Illustrative* — a parent constraint clashing with a child-local one.

```text
ERROR:  constraint "chk" conflicts with non-inherited constraint on child table "child"
```

## Related

- [constraint conflicts with non-inherited constraint on relation](./constraint-conflicts-with-non-inherited-constraint-on-relation.md)
- [constraint conflicts with NOT ENFORCED constraint on child table](./constraint-conflicts-with-not-enforced-constraint-on-child-table.md)
