---
message: "%s is a table's row type"
slug: is-a-table-s-row-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_WRONG_OBJECT_TYPE
    code: "42809"
call_sites:
  - "postgres/src/backend/commands/typecmds.c:3822"
  - "postgres/src/backend/commands/typecmds.c:3907"
  - "postgres/src/backend/commands/typecmds.c:4261"
reproduced: false
---

# `%s is a table's row type`

## What it means

A command tried to operate on a composite type that is a table's implicit row type, rather than on a standalone type. Every table has an automatically created row type, and that row type cannot be altered or dropped independently of its table.

## When it happens

Running `ALTER TYPE` or `DROP TYPE` against the row type Postgres created for a table, instead of against a type defined with `CREATE TYPE`. The name resolves to the table's companion row type.

## How to fix

Operate on the table instead. To change the columns, use `ALTER TABLE`; to remove the type, drop the table. A table's row type follows its table and cannot be managed on its own.

## Example

*Illustrative* — altering a table's row type directly.

```sql
ALTER TYPE orders ADD ATTRIBUTE note text;  -- orders is a table's row type
```

## Related

- [is a composite type](./is-a-composite-type.md)
- [is not a composite type](./is-not-a-composite-type.md)
