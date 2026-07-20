---
message: "default for column \"%s\" cannot be cast automatically to type %s"
slug: default-for-column-cannot-be-cast-automatically-to-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DATATYPE_MISMATCH
    code: "42804"
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:15360"
reproduced: false
---

# `default for column "%s" cannot be cast automatically to type %s`

## What it means

`ALTER TABLE ... ALTER COLUMN TYPE` changed a column's type, but the column's existing `DEFAULT` expression cannot be converted to the new type without an explicit cast. The placeholders are the column name and the new type.

## When it happens

It fires during `ALTER COLUMN ... TYPE` when no implicit or assignment cast exists from the default expression's type to the new column type.

## How to fix

Drop or replace the default as part of the change. Either `ALTER COLUMN ... DROP DEFAULT` before the type change and set a new one after, or run the type change and default change together so the new default already has the right type.

## Example

*Illustrative* — retyping a column whose default cannot auto-cast.

```sql
ALTER TABLE t ALTER COLUMN c TYPE inet;
-- default for column "c" cannot be cast automatically to type inet
```

## Related

- [default value for column of relation does not exist](./default-value-for-column-of-relation-does-not-exist.md)
- [DEFAULT is not allowed in this context](./default-is-not-allowed-in-this-context.md)
