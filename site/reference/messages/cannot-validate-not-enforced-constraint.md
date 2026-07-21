---
message: "cannot validate NOT ENFORCED constraint"
slug: cannot-validate-not-enforced-constraint
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:13490"
reproduced: false
---

# `cannot validate NOT ENFORCED constraint`

## What it means

A `VALIDATE CONSTRAINT` targeted a constraint marked `NOT ENFORCED`. Validation confirms existing rows satisfy an enforced constraint, and an unenforced constraint is not checked at all, so validating it has no meaning.

## When it happens

It occurs on `ALTER TABLE ... VALIDATE CONSTRAINT` for a constraint that was defined or altered to `NOT ENFORCED`.

## How to fix

Make the constraint enforced first with `ALTER TABLE ... ALTER CONSTRAINT ... ENFORCED`, which checks existing rows, or leave it unenforced and skip validation.

## Example

*Illustrative* — validating an unenforced constraint.

```text
ERROR:  cannot validate NOT ENFORCED constraint
```

## Related

- [cannot validate constraint of relation](./cannot-validate-constraint-of-relation.md)
- [check constraint already exists](./check-constraint-already-exists.md)
