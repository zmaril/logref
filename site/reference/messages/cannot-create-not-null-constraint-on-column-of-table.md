---
message: "cannot create not-null constraint \"%s\" on column \"%s\" of table \"%s\""
slug: cannot-create-not-null-constraint-on-column-of-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/catalog/pg_constraint.c:790"
reproduced: false
---

# `cannot create not-null constraint "%s" on column "%s" of table "%s"`

## What it means

A `NOT NULL` constraint could not be created on the named column of the named table because the column's context does not permit it — for example a system column or a column whose definition conflicts with the constraint. The placeholders are the constraint, column, and table names.

## When it happens

It occurs during `ALTER TABLE ... ADD CONSTRAINT` or table creation when a not-null constraint is requested on a column that cannot carry one.

## How to fix

Apply the not-null constraint only to ordinary user columns that can hold it. Review the column's definition and role in the table so the constraint is valid.

## Example

*Illustrative* — a not-null on an ineligible column.

```text
ERROR:  cannot create not-null constraint "c" on column "x" of table "t"
```

## Related

- [cannot define not-null constraint with no inherit on column](./cannot-define-not-null-constraint-with-no-inherit-on-column.md)
- [cannot drop column because it is part of the partition key of relation](./cannot-drop-column-because-it-is-part-of-the-partition-key-of-relation.md)
