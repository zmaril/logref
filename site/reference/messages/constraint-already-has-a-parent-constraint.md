---
message: "constraint %u already has a parent constraint"
slug: constraint-already-has-a-parent-constraint
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/catalog/pg_constraint.c:1148"
reproduced: false
---

# `constraint %u already has a parent constraint`

## What it means

An internal step tried to attach a constraint to a parent constraint, but that constraint is already linked to a parent. A constraint can have only one parent in the inheritance hierarchy. This is an internal consistency check.

## When it happens

It fires during partition or inheritance operations that clone and link constraints when the child constraint already records a parent.

## How to fix

This is an internal error rather than a user-facing one. It can indicate catalog inconsistency from an interrupted DDL operation. Note the operation that triggered it and investigate the constraint hierarchy; report it if it recurs on an otherwise healthy catalog.

## Example

*Illustrative* — a constraint already having a parent.

```text
ERROR:  constraint 16482 already has a parent constraint
```

## Related

- [constraint is not of a known type](./constraint-is-not-of-a-known-type.md)
- [constraint conflicts with inherited constraint on relation](./constraint-conflicts-with-inherited-constraint-on-relation.md)
