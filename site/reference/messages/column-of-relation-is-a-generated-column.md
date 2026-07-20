---
message: "column \"%s\" of relation \"%s\" is a generated column"
slug: column-of-relation-is-a-generated-column
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:8301"
reproduced: false
---

# `column "%s" of relation "%s" is a generated column`

## What it means

A statement tried to assign directly to a generated column, or otherwise treat it as writable. Generated columns are computed from their expression and cannot be given values directly.

## When it happens

It happens on `INSERT`/`UPDATE` that targets a generated column with a value, or on operations that require a plain writable column but were given a generated one.

## How to fix

Do not write to the generated column; let Postgres compute it. If you must control its value, redesign the column as a plain column with a trigger or application logic instead of a generation expression.

## Example

*Illustrative* — updating a generated column.

```sql
UPDATE t SET g = 5;
-- ERROR:  column "g" of relation "t" is a generated column
```

## Related

- [column is a generated column](./column-is-a-generated-column.md)
- [column can only be updated to default](./column-can-only-be-updated-to-default.md)
