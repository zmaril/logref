---
message: "constraint \"%s\" is not deferrable"
slug: constraint-is-not-deferrable
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/trigger.c:5971"
reproduced: false
---

# `constraint "%s" is not deferrable`

## What it means

A `SET CONSTRAINTS ... DEFERRED` (or trigger-timing operation) named a constraint that was not declared `DEFERRABLE`. Only deferrable constraints can have their checking postponed.

## When it happens

It happens on `SET CONSTRAINTS name DEFERRED` when the named constraint was created without `DEFERRABLE`.

## How to fix

Recreate the constraint with `DEFERRABLE` (and optionally `INITIALLY DEFERRED`) if you need to defer it, or remove the `SET CONSTRAINTS` for it. Non-deferrable constraints are always checked immediately.

## Example

*Illustrative* — deferring a non-deferrable constraint.

```sql
SET CONSTRAINTS my_fk DEFERRED;
-- ERROR:  constraint "my_fk" is not deferrable
```

## Related

- [constraint in ON CONFLICT clause has no associated index](./constraint-in-on-conflict-clause-has-no-associated-index.md)
- [constraint does not exist](./constraint-does-not-exist.md)
