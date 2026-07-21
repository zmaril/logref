---
message: "default value for column \"%s\" of relation \"%s\" does not exist"
slug: default-value-for-column-of-relation-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_COLUMN
    code: "42703"
call_sites:
  - "postgres/src/backend/catalog/objectaddress.c:1685"
reproduced: false
---

# `default value for column "%s" of relation "%s" does not exist`

## What it means

A command referenced the `DEFAULT` of a specific column, and that column has no default defined. The placeholders are the column and relation names.

## When it happens

It fires while resolving an object address for a column default — for example a `COMMENT` or dependency lookup on a default that was never set or was dropped.

## How to fix

Confirm the column actually has a default with `\d relation` in psql (it appears in the `Default` column) or by querying `pg_attrdef`. Set one with `ALTER TABLE ... ALTER COLUMN ... SET DEFAULT` before referencing it.

## Example

*Illustrative* — referencing a default that is not set.

```text
ERROR:  default value for column "c" of relation "t" does not exist
```

## Related

- [default for column cannot be cast automatically to type](./default-for-column-cannot-be-cast-automatically-to-type.md)
- [DEFAULT is not allowed in this context](./default-is-not-allowed-in-this-context.md)
