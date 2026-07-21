---
message: "column \"%s\" is in a primary key"
slug: column-is-in-a-primary-key
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_TABLE_DEFINITION
    code: "42P16"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:14693"
reproduced: false
---

# `column "%s" is in a primary key`

## What it means

An `ALTER TABLE` operation tried to change a column in a way that is not allowed while the column participates in a primary key, such as dropping its `NOT NULL` marking. Primary-key columns must stay non-null.

## When it happens

It happens on `ALTER TABLE ... ALTER COLUMN ... DROP NOT NULL` (and similar) when the target column is part of the table's primary key.

## How to fix

Drop or alter the primary-key constraint first if you genuinely need to change the column, then re-add a suitable key afterward. Primary-key columns cannot be made nullable while the key exists.

## Example

*Illustrative* — dropping NOT NULL from a primary-key column.

```sql
CREATE TABLE t (id int PRIMARY KEY);
ALTER TABLE t ALTER COLUMN id DROP NOT NULL;
-- ERROR:  column "id" is in a primary key
```

## Related

- [column is in index used as replica identity](./column-is-in-index-used-as-replica-identity.md)
- [column is marked NOT NULL in parent table](./column-is-marked-not-null-in-parent-table.md)
