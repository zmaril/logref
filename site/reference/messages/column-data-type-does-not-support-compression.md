---
message: "column data type %s does not support compression"
slug: column-data-type-does-not-support-compression
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:22810"
reproduced: false
---

# `column data type %s does not support compression`

## What it means

A `SET COMPRESSION` or column definition tried to set a compression method on a column whose type cannot be compressed. Compression applies only to variable-length, TOASTable types, so the request is rejected.

## When it happens

It occurs on `ALTER TABLE ... ALTER COLUMN ... SET COMPRESSION` or a column definition when the type is not a compressible variable-length type.

## How to fix

Set compression only on variable-length types such as `text`, `bytea`, or `jsonb`. Remove the compression clause for types that do not support it.

## Example

*Illustrative* — compression on an unsupported type.

```sql
ALTER TABLE t ALTER COLUMN i SET COMPRESSION lz4;
-- ERROR:  column data type integer does not support compression
```

## Related

- [column data type can only have storage PLAIN](./column-data-type-can-only-have-storage-plain.md)
- [column cannot be cast automatically to type](./column-cannot-be-cast-automatically-to-type.md)
