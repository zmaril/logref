---
message: "constraint %u is not a not-null constraint"
slug: constraint-is-not-a-not-null-constraint
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:9718"
reproduced: false
---

# `constraint %u is not a not-null constraint`

## What it means

Internal code that expected a not-null constraint (identified by OID) found a constraint of a different kind. This is a consistency check in table-command handling of not-null constraints.

## When it happens

It fires from `tablecmds` code when a constraint OID being processed as a not-null constraint turns out to be something else.

## How to fix

This is an internal error, not a user-facing one. It may point to catalog inconsistency from an interrupted operation. Record what triggered it and inspect the constraint; report it if it recurs on an unmodified catalog.

## Example

*Illustrative* — a non-not-null constraint where one was expected.

```text
ERROR:  constraint 16491 is not a not-null constraint
```

## Related

- [constraint is not a foreign key constraint](./constraint-is-not-a-foreign-key-constraint.md)
- [constraint of relation is not a not-null constraint](./constraint-of-relation-is-not-a-not-null-constraint.md)
