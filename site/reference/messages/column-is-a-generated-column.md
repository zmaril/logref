---
message: "column \"%s\" is a generated column"
slug: column-is-a-generated-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_COLUMN_REFERENCE
    code: "42P10"
call_sites:
  - "postgres/src/backend/commands/copy.c:1109"
reproduced: false
---

# `column "%s" is a generated column`

## What it means

A `COPY` command tried to read data into a generated column. Generated columns are computed from other columns; their values cannot be supplied directly, so they are not allowed in a `COPY FROM` column list.

## When it happens

It happens with `COPY table (cols...) FROM ...` when one of the listed columns is a generated column.

## How to fix

Remove the generated column from the `COPY` column list. Its value is produced automatically from the columns it depends on once the row is inserted.

## Example

*Illustrative* — COPY listing a generated column.

```sql
CREATE TABLE t (a int, b int GENERATED ALWAYS AS (a * 2) STORED);
COPY t (a, b) FROM STDIN;
-- ERROR:  column "b" is a generated column
```

## Related

- [column of relation is a generated column](./column-of-relation-is-a-generated-column.md)
- [column in child table must be a generated column](./column-in-child-table-must-be-a-generated-column.md)
