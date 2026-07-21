---
message: "constraint %u is not a foreign key constraint"
slug: constraint-is-not-a-foreign-key-constraint
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/utils/adt/ri_triggers.c:2455"
reproduced: false
---

# `constraint %u is not a foreign key constraint`

## What it means

Internal code that expected a foreign-key constraint (identified by OID) found a constraint of a different kind. This is a consistency check in referential-integrity handling.

## When it happens

It fires from RI trigger code when a constraint OID it looks up is not a foreign key as expected.

## How to fix

This is an internal error rather than a user mistake. It can indicate catalog inconsistency. Note the operation that triggered it and inspect the constraint; report it if it recurs on a healthy catalog.

## Example

*Illustrative* — a non-FK constraint where an FK was expected.

```text
ERROR:  constraint 16490 is not a foreign key constraint
```

## Related

- [constraint is not a not-null constraint](./constraint-is-not-a-not-null-constraint.md)
- [constraint is not of a known type](./constraint-is-not-of-a-known-type.md)
