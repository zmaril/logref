---
message: "check constraint \"%s\" already exists"
slug: check-constraint-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/catalog/heap.c:2543"
reproduced: false
---

# `check constraint "%s" already exists`

## What it means

A `CHECK` constraint was added under a name that another constraint on the table already uses. Constraint names must be unique per table, so the duplicate is rejected.

## When it happens

It occurs on `ALTER TABLE ... ADD CONSTRAINT name CHECK (...)` or `CREATE TABLE` when `name` is already taken on the same table.

## How to fix

Choose a different constraint name, or drop the existing constraint first if you mean to replace it. Let the server generate a name by omitting the explicit one if you do not need a specific label.

## Example

*Illustrative* — a duplicate check-constraint name.

```sql
ALTER TABLE t ADD CONSTRAINT c CHECK (a > 0);
-- ERROR:  check constraint "c" already exists
```

## Related

- [check constraint name appears multiple times but with different expressions](./check-constraint-name-appears-multiple-times-but-with-different-expressions.md)
- [column appears twice in unique constraint](./column-appears-twice-in-unique-constraint.md)
