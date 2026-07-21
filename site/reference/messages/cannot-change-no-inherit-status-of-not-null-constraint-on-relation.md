---
message: "cannot change NO INHERIT status of NOT NULL constraint \"%s\" on relation \"%s\""
slug: cannot-change-no-inherit-status-of-not-null-constraint-on-relation
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/catalog/pg_constraint.c:762"
  - "postgres/src/backend/commands/tablecmds.c:8101"
reproduced: false
---

# `cannot change NO INHERIT status of NOT NULL constraint "%s" on relation "%s"`

## What it means

A command tried to switch a not-null constraint between inheritable and NO INHERIT on a table, which is not allowed once the constraint exists. The placeholders are the constraint name and the relation. Whether a not-null constraint is inherited by children is fixed at definition time.

## When it happens

An `ALTER TABLE` that would flip the NO INHERIT property of an existing not-null constraint, often while reconciling inheritance between a parent and its partitions or child tables.

## How to fix

Drop the not-null constraint and re-add it with the desired inheritance behavior, rather than trying to change it in place. Plan the inheritance property when the constraint is first created.

## Example

*Illustrative* — flipping NO INHERIT on an existing not-null constraint.

```text
ERROR:  cannot change NO INHERIT status of NOT NULL constraint "nn_id" on relation "child"
```

## Related

- [conflicting NO INHERIT declaration for not-null constraint on column](./conflicting-no-inherit-declaration-for-not-null-constraint-on-column.md)
- [constraint must be added to child tables too](./constraint-must-be-added-to-child-tables-too.md)
