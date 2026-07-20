---
message: "constraint in ON CONFLICT clause has no associated index"
slug: constraint-in-on-conflict-clause-has-no-associated-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/optimizer/util/plancat.c:911"
reproduced: false
---

# `constraint in ON CONFLICT clause has no associated index`

## What it means

An `INSERT ... ON CONFLICT ON CONSTRAINT name` named a constraint that is not backed by a unique index. `ON CONFLICT` arbitration needs a unique or exclusion index, so a constraint without one cannot be used.

## When it happens

It happens when the constraint named in `ON CONFLICT ON CONSTRAINT` is, for example, a foreign key or check constraint rather than a unique/primary-key/exclusion constraint.

## How to fix

Reference a unique, primary-key, or exclusion constraint in the `ON CONFLICT` clause, or use the column-list form `ON CONFLICT (cols)`. Only index-backed constraints can arbitrate conflicts.

## Example

*Illustrative* — ON CONFLICT on a non-index constraint.

```sql
INSERT INTO t VALUES (1) ON CONFLICT ON CONSTRAINT t_fk DO NOTHING;
-- ERROR:  constraint "t_fk" in ON CONFLICT clause has no associated index
```

## Related

- [conflicting key value violates exclusion constraint](./conflicting-key-value-violates-exclusion-constraint.md)
- [constraint must be PRIMARY, UNIQUE or EXCLUDE](./constraint-must-be-primary-unique-or-exclude.md)
