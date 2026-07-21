---
message: "column data type %s can only have storage PLAIN"
slug: column-data-type-can-only-have-storage-plain
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:22853"
reproduced: true
---

# `column data type %s can only have storage PLAIN`

## What it means

A `SET STORAGE` or column definition tried to give a fixed-length, by-value data type a storage mode other than `PLAIN`. Such types are never TOASTed, so only `PLAIN` storage applies to them.

## When it happens

It occurs on `ALTER TABLE ... ALTER COLUMN ... SET STORAGE` or a column definition when the column's type is a fixed-length type such as `integer` and a mode like `EXTENDED` or `EXTERNAL` is requested.

## How to fix

Leave the storage mode as `PLAIN` for fixed-length types, or set alternative storage modes only on variable-length types such as `text` or `bytea`.

## Example

*Reproduced* — captured from `reproducers/scenarios/27_alter_table.sql`.

```sql
ALTER TABLE repro.at ALTER COLUMN a SET STORAGE MAIN;
```

Produces:

```text
ERROR:  column data type integer can only have storage PLAIN
```

## Related

- [column data type does not support compression](./column-data-type-does-not-support-compression.md)
- [column cannot be cast automatically to type](./column-cannot-be-cast-automatically-to-type.md)
