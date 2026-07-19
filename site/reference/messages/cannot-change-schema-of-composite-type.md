---
message: "cannot change schema of composite type \"%s\""
slug: cannot-change-schema-of-composite-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:20435"
reproduced: false
---

# `cannot change schema of composite type "%s"`

## What it means

An `ALTER TYPE ... SET SCHEMA` targeted the composite type that is automatically created for a table's row type. That type's schema follows its table, so it cannot be moved on its own. The placeholder is the type name.

## When it happens

It occurs when trying to move a table's implicit row type to another schema directly with `ALTER TYPE ... SET SCHEMA`.

## How to fix

Move the owning table with `ALTER TABLE ... SET SCHEMA`; its row type follows. Only standalone composite types created with `CREATE TYPE` can have their schema changed directly.

## Example

*Illustrative* — moving a table's row type.

```text
ERROR:  cannot change schema of composite type "t"
```

## Related

- [cannot change schema of index](./cannot-change-schema-of-index.md)
- [cannot change schema of toast table](./cannot-change-schema-of-toast-table.md)
