---
message: "cannot alter enforceability of constraint \"%s\" of relation \"%s\""
slug: cannot-alter-enforceability-of-constraint-of-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:12404"
reproduced: false
---

# `cannot alter enforceability of constraint "%s" of relation "%s"`

## What it means

An `ALTER TABLE ... ALTER CONSTRAINT` tried to change whether a constraint is enforced, but this constraint's enforceability cannot be changed. The placeholders name the constraint and relation. Not every constraint type supports toggling enforcement.

## When it happens

It occurs when switching a constraint between `ENFORCED` and `NOT ENFORCED` for a constraint kind that does not permit it.

## How to fix

Leave the constraint's enforcement as defined, or drop and recreate the constraint with the enforcement you want. Enforcement toggling applies only to the constraint types that support it.

## Example

*Illustrative* — an unsupported enforceability change.

```text
ERROR:  cannot alter enforceability of constraint "c" of relation "t"
```

## Related

- [cannot alter constraint on relation](./cannot-alter-constraint-on-relation.md)
- [cannot alter inherited constraint on relation](./cannot-alter-inherited-constraint-on-relation.md)
