---
message: "cannot alter constraint \"%s\" on relation \"%s\""
slug: cannot-alter-constraint-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:12465"
reproduced: false
---

# `cannot alter constraint "%s" on relation "%s"`

## What it means

An `ALTER TABLE ... ALTER CONSTRAINT` targeted a constraint whose attributes cannot be altered in the requested way. The placeholders name the constraint and relation. Only certain constraint properties, mainly the deferrability of foreign keys, can be altered.

## When it happens

It occurs when altering a constraint that does not support the change — for example altering deferrability on a constraint type that is not deferrable.

## How to fix

Alter only the properties a constraint supports, such as `DEFERRABLE`/`INITIALLY DEFERRED` on a foreign key. For other changes, drop the constraint and add a new one with the desired definition.

## Example

*Illustrative* — an unsupported constraint alteration.

```text
ERROR:  cannot alter constraint "c" on relation "t"
```

## Related

- [cannot alter inherited constraint on relation](./cannot-alter-inherited-constraint-on-relation.md)
- [cannot alter enforceability of constraint of relation](./cannot-alter-enforceability-of-constraint-of-relation.md)
