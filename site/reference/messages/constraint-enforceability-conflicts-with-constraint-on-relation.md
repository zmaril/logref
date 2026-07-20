---
message: "constraint \"%s\" enforceability conflicts with constraint \"%s\" on relation \"%s\""
slug: constraint-enforceability-conflicts-with-constraint-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_OBJECT_DEFINITION
    code: "42P17"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:11900"
reproduced: false
---

# `constraint "%s" enforceability conflicts with constraint "%s" on relation "%s"`

## What it means

A constraint being added has an enforceability (ENFORCED vs NOT ENFORCED) that conflicts with another constraint of the same name on the relation. The two definitions disagree on whether the constraint is enforced.

## When it happens

It happens on `ALTER TABLE ... ADD CONSTRAINT` when a same-named constraint already exists with the opposite enforcement status.

## How to fix

Make the enforcement status consistent, or use a different constraint name. Decide whether the constraint should be `ENFORCED`, adjust accordingly, and avoid two same-named constraints with conflicting states.

## Example

*Illustrative* — conflicting enforceability for a constraint.

```text
ERROR:  constraint "chk" enforceability conflicts with constraint "chk" on relation "t"
```

## Related

- [constraint conflicts with NOT ENFORCED constraint on relation](./constraint-conflicts-with-not-enforced-constraint-on-relation.md)
- [constraint must be altered in child tables too](./constraint-must-be-altered-in-child-tables-too.md)
