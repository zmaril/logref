---
message: "cannot move an owned sequence into another schema"
slug: cannot-move-an-owned-sequence-into-another-schema
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:19684"
reproduced: true
---

# `cannot move an owned sequence into another schema`

## What it means

An `ALTER SEQUENCE ... SET SCHEMA` targeted a sequence that is owned by a table column. An owned sequence — one created by `SERIAL`/`IDENTITY` or attached with `OWNED BY` — follows its owning table and cannot be moved to another schema on its own.

## When it happens

It occurs when you try to move a sequence that backs an identity or serial column, or that was explicitly marked `OWNED BY` a column, into a different schema.

## How to fix

Move the owning table to the target schema, which brings the sequence with it, or detach the sequence with `ALTER SEQUENCE ... OWNED BY NONE` before moving it. Reattach the ownership afterwards if needed.

## Example

*Reproduced* — captured from `reproducers/scenarios/35_ddl_object_lifecycle.sql`.

```sql
ALTER SEQUENCE s35.owner_seq_id_seq SET SCHEMA public;
```

Produces:

```text
ERROR:  cannot move an owned sequence into another schema
```

## Related

- [cannot move objects into or out of temporary schemas](./cannot-move-objects-into-or-out-of-temporary-schemas.md)
- [cannot move extension into schema because the extension contains the schema](./cannot-move-extension-into-schema-because-the-extension-contains-the-schema.md)
