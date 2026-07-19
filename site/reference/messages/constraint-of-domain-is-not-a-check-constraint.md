---
message: "constraint \"%s\" of domain \"%s\" is not a check constraint"
slug: constraint-of-domain-is-not-a-check-constraint
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:3128"
reproduced: false
---

# `constraint "%s" of domain "%s" is not a check constraint`

## What it means

An operation that only applies to a domain's check constraint named a constraint of a different kind (such as a not-null constraint). Only check constraints can be targeted here.

## When it happens

It happens on `ALTER DOMAIN ... VALIDATE CONSTRAINT` or similar when the named domain constraint is not a `CHECK` constraint.

## How to fix

Target a check constraint, or use the appropriate command for the constraint's actual type. Confirm the constraint kind before referencing it.

## Example

*Illustrative* — validating a non-check domain constraint.

```text
ERROR:  constraint "c" of domain "d" is not a check constraint
```

## Related

- [constraint for domain does not exist](./constraint-for-domain-does-not-exist.md)
- [constraint of relation is not a not-null constraint](./constraint-of-relation-is-not-a-not-null-constraint.md)
