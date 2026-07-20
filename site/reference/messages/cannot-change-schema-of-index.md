---
message: "cannot change schema of index \"%s\""
slug: cannot-change-schema-of-index
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:20429"
reproduced: false
---

# `cannot change schema of index "%s"`

## What it means

An `ALTER ... SET SCHEMA` targeted an index directly. An index always lives in the schema of its table, so its schema cannot be changed independently. The placeholder is the index name.

## When it happens

It occurs when trying to move an index to another schema on its own.

## How to fix

Move the index's table with `ALTER TABLE ... SET SCHEMA`; the index follows automatically. Indexes are not moved between schemas independently of their tables.

## Example

*Illustrative* — moving an index's schema.

```text
ERROR:  cannot change schema of index "t_idx"
```

## Related

- [cannot change schema of composite type](./cannot-change-schema-of-composite-type.md)
- [cannot change schema of toast table](./cannot-change-schema-of-toast-table.md)
