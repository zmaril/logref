---
message: "column \"%s\" referenced in foreign key constraint does not exist"
slug: column-referenced-in-foreign-key-constraint-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:13879"
reproduced: true
---

# `column "%s" referenced in foreign key constraint does not exist`

## What it means

A foreign-key definition named a column that does not exist on the referencing or referenced table. The key columns must be real columns of the tables involved.

## When it happens

It happens on `CREATE TABLE` or `ALTER TABLE ... ADD FOREIGN KEY` when a column in the `FOREIGN KEY (...)` or `REFERENCES tab (...)` list is misspelled or missing.

## How to fix

Use column names that exist on both tables. Check the spelling and confirm the columns are present with `\d table`.

## Example

*Reproduced* — captured from `reproducers/scenarios/31_createtable_view_trigger.sql`.

```sql
CREATE TABLE repro.ct2 (a int REFERENCES repro.parent(nonexistent));
```

Produces:

```text
ERROR:  column "nonexistent" referenced in foreign key constraint does not exist
```

## Related

- [column referenced in ON DELETE SET action must be part of foreign key](./column-referenced-in-on-delete-set-action-must-be-part-of-foreign-key.md)
- [column of relation does not exist](./column-number-of-relation-does-not-exist.md)
