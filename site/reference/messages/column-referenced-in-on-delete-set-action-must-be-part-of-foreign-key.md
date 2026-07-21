---
message: "column \"%s\" referenced in ON DELETE SET action must be part of foreign key"
slug: column-referenced-in-on-delete-set-action-must-be-part-of-foreign-key
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:10819"
reproduced: false
---

# `column "%s" referenced in ON DELETE SET action must be part of foreign key`

## What it means

A foreign key's `ON DELETE SET NULL (cols)` or `ON DELETE SET DEFAULT (cols)` listed a column that is not one of the foreign-key columns. The set action may only touch columns that make up the key.

## When it happens

It happens on `CREATE TABLE`/`ALTER TABLE` defining a foreign key whose `ON DELETE SET ...` column list includes a non-key column.

## How to fix

Restrict the `SET NULL`/`SET DEFAULT` column list to columns that are part of the foreign key, or add the column to the key if it truly should participate.

## Example

*Illustrative* — a set-column outside the foreign key.

```sql
ALTER TABLE t ADD FOREIGN KEY (a) REFERENCES p (id)
  ON DELETE SET NULL (b);
-- ERROR:  column "b" referenced in ON DELETE SET action must be part of foreign key
```

## Related

- [column referenced in foreign key constraint does not exist](./column-referenced-in-foreign-key-constraint-does-not-exist.md)
- [constraint is not a foreign key constraint](./constraint-is-not-a-foreign-key-constraint.md)
