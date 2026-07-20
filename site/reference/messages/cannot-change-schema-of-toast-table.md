---
message: "cannot change schema of TOAST table \"%s\""
slug: cannot-change-schema-of-toast-table
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:20443"
reproduced: false
---

# `cannot change schema of TOAST table "%s"`

## What it means

An `ALTER ... SET SCHEMA` targeted a TOAST table directly. A TOAST table is an internal companion of its main table and always lives in the same schema, so it cannot be moved on its own. The placeholder is the TOAST table name.

## When it happens

It occurs when trying to move a `pg_toast` companion table to another schema directly.

## How to fix

Move the main table with `ALTER TABLE ... SET SCHEMA`; its TOAST table follows. TOAST tables are managed automatically and are never moved independently.

## Example

*Illustrative* — moving a TOAST table's schema.

```text
ERROR:  cannot change schema of TOAST table "pg_toast_16384"
```

## Related

- [cannot change schema of index](./cannot-change-schema-of-index.md)
- [cannot change toast relation](./cannot-change-toast-relation.md)
