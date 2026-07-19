---
message: "column \"%s\" is in index used as replica identity"
slug: column-is-in-index-used-as-replica-identity
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:14701"
reproduced: false
---

# `column "%s" is in index used as replica identity`

## What it means

An operation tried to drop the `NOT NULL` marking of a column that is part of the index chosen as the table's replica identity. Replica-identity index columns must remain non-null so that changes can be replicated unambiguously.

## When it happens

It happens on `ALTER TABLE ... ALTER COLUMN ... DROP NOT NULL` when the column belongs to the unique index set with `REPLICA IDENTITY USING INDEX`.

## How to fix

Change the table's replica identity first (for example to `DEFAULT`, `FULL`, or a different index) if you must make the column nullable, then adjust the column. Otherwise leave the column `NOT NULL`.

## Example

*Illustrative* — dropping NOT NULL from a replica-identity index column.

```sql
ALTER TABLE t ALTER COLUMN id DROP NOT NULL;
-- ERROR:  column "id" is in index used as replica identity
```

## Related

- [column is in a primary key](./column-is-in-a-primary-key.md)
- [column is marked NOT NULL in parent table](./column-is-marked-not-null-in-parent-table.md)
