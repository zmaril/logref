---
message: "constraint must be validated on child tables too"
slug: constraint-must-be-validated-on-child-tables-too
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:13702"
  - "postgres/src/backend/commands/tablecmds.c:13802"
reproduced: false
---

# `constraint must be validated on child tables too`

## What it means

A `VALIDATE CONSTRAINT ... ONLY` on a parent could not proceed because validation must also cover the child tables, and `ONLY` excludes them. A constraint cannot be marked valid on the parent while children remain unvalidated.

## When it happens

Running `ALTER TABLE ONLY parent VALIDATE CONSTRAINT c` on an inheritance or partition hierarchy where the children still hold the constraint as `NOT VALID`.

## How to fix

Validate the constraint without `ONLY` so children are validated too, or validate each child's constraint first and then the parent. Validation must be complete across the hierarchy before the constraint is considered valid.

## Example

*Illustrative* — validating ONLY the parent.

```sql
ALTER TABLE ONLY parent VALIDATE CONSTRAINT c;
-- ERROR:  constraint must be validated on child tables too
```

## Related

- [constraint must be added to child tables too](./constraint-must-be-added-to-child-tables-too.md)
- [check constraint of relation is violated by some row](./check-constraint-of-relation-is-violated-by-some-row.md)
