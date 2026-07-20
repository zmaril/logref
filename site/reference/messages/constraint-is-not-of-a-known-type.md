---
message: "constraint %u is not of a known type"
slug: constraint-is-not-of-a-known-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_constraint.c:984"
reproduced: false
---

# `constraint %u is not of a known type`

## What it means

Internal code reading a constraint (by OID) found a constraint type value it does not recognize. Every constraint should be one of the known kinds, so an unknown one is a consistency error.

## When it happens

It fires from catalog code in `pg_constraint` handling when the `contype` value is not a recognized constraint type.

## How to fix

This indicates catalog corruption or manual catalog tampering rather than a normal error. Investigate the affected constraint, restore from backup if the catalog is damaged, and avoid direct edits to `pg_constraint`.

## Example

*Illustrative* — an unrecognized constraint type.

```text
ERROR:  constraint 16492 is not of a known type
```

## Related

- [constraint is not a foreign key constraint](./constraint-is-not-a-foreign-key-constraint.md)
- [constraint must be PRIMARY, UNIQUE or EXCLUDE](./constraint-must-be-primary-unique-or-exclude.md)
