---
message: "constraint \"%s\" conflicts with NOT ENFORCED constraint on child table \"%s\""
slug: constraint-conflicts-with-not-enforced-constraint-on-child-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:18467"
reproduced: false
---

# `constraint "%s" conflicts with NOT ENFORCED constraint on child table "%s"`

## What it means

A constraint being propagated to a child conflicts with a `NOT ENFORCED` constraint already present on the child. The child's non-enforced constraint of the same name blocks the inherited one, because their enforcement status differs.

## When it happens

It happens when adding an (enforced) constraint on a parent that would propagate to a child which already has a same-named `NOT ENFORCED` constraint.

## How to fix

Align the enforcement status, or rename one of the constraints. Either make the child's constraint enforced to match, drop it, or choose a distinct name for the parent constraint.

## Example

*Illustrative* — an enforced parent constraint vs a NOT ENFORCED child one.

```text
ERROR:  constraint "chk" conflicts with NOT ENFORCED constraint on child table "child"
```

## Related

- [constraint conflicts with NOT ENFORCED constraint on relation](./constraint-conflicts-with-not-enforced-constraint-on-relation.md)
- [constraint conflicts with NOT VALID constraint on child table](./constraint-conflicts-with-not-valid-constraint-on-child-table.md)
