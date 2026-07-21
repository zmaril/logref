---
message: "column \"%s\" of relation \"%s\" contains null values"
slug: column-of-relation-contains-null-values
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_NOT_NULL_VIOLATION
    code: "23502"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:6577"
  - "postgres/src/backend/commands/tablecmds.c:6597"
reproduced: false
---

# `column "%s" of relation "%s" contains null values`

## What it means

Adding a NOT NULL constraint (or setting a column NOT NULL) failed because the column already holds NULLs in existing rows. The placeholders are the column and the relation. Postgres scanned the table and found values the constraint would forbid.

## When it happens

`ALTER TABLE ... ALTER COLUMN ... SET NOT NULL`, adding a primary key, or otherwise marking a column NOT NULL on a table whose rows contain NULLs in that column.

## How to fix

Populate or remove the NULL rows before adding the constraint — `UPDATE` them to a real value, delete them, or supply a `DEFAULT` and backfill. Then set the column NOT NULL. Run `SELECT ... WHERE col IS NULL` to find the offending rows first.

## Example

*Illustrative* — NULLs block a NOT NULL constraint.

```sql
ALTER TABLE t ALTER COLUMN email SET NOT NULL;
-- ERROR:  column "email" of relation "t" contains null values
```

## Related

- [check constraint of relation is violated by some row](./check-constraint-of-relation-is-violated-by-some-row.md)
- [column in child table must be marked NOT NULL](./column-in-child-table-must-be-marked-not-null.md)
