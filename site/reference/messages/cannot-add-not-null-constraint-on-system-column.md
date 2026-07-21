---
message: "cannot add not-null constraint on system column \"%s\""
slug: cannot-add-not-null-constraint-on-system-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/catalog/heap.c:2644"
  - "postgres/src/backend/catalog/heap.c:2967"
reproduced: false
---

# `cannot add not-null constraint on system column "%s"`

## What it means

A command tried to place a NOT NULL constraint on a system column (such as `ctid`, `xmin`, or `tableoid`). The placeholder is the column name. System columns are managed by Postgres and cannot carry user-defined constraints.

## When it happens

An `ALTER TABLE ... ALTER COLUMN ... SET NOT NULL` or a table definition that names a system column, usually a mistake in a migration where a system-column name collides with the intended target.

## How to fix

Apply the constraint to a user-defined column instead. System columns already have fixed semantics and never need a NOT NULL constraint. Check the column name in the failing statement for a typo or an unintended system-column reference.

## Example

*Illustrative* — targeting a system column.

```sql
ALTER TABLE t ALTER COLUMN ctid SET NOT NULL;
-- ERROR:  cannot add not-null constraint on system column "ctid"
```

## Related

- [column name conflicts with a system column name](./column-name-conflicts-with-a-system-column-name.md)
- [cannot set system attribute](./cannot-set-system-attribute.md)
