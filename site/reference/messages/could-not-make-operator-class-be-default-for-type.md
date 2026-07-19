---
message: "could not make operator class \"%s\" be default for type %s"
slug: could-not-make-operator-class-be-default-for-type
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/commands/opclasscmds.c:656"
reproduced: false
---

# `could not make operator class "%s" be default for type %s`

## What it means

A `CREATE OPERATOR CLASS ... DEFAULT` or `ALTER OPERATOR FAMILY` asked to mark an operator class as the default for a type, but that type already has a default operator class for the same access method. A type can have only one default per access method.

## When it happens

It happens when defining or altering an operator class as the default for a type that already has one — for example adding a second default b-tree operator class for an existing type.

## How to fix

Only one operator class per access method may be the default for a type. Drop or un-default the existing default first, or define the new class without `DEFAULT` and reference it explicitly in index definitions with `USING`.

## Example

*Illustrative* — a second default operator class for a type.

```sql
CREATE OPERATOR CLASS my_ops DEFAULT FOR TYPE int4 USING btree AS ...;
-- ERROR:  could not make operator class "my_ops" be default for type integer
-- DETAIL:  Operator class "int4_ops" already is the default.
```

## Related

- [could not open extension control file](./could-not-open-extension-control-file.md)
- [could not parse reloptions array](./could-not-parse-reloptions-array.md)
