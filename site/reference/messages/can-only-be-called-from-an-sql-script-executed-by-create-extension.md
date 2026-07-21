---
message: "%s can only be called from an SQL script executed by CREATE EXTENSION"
slug: can-only-be-called-from-an-sql-script-executed-by-create-extension
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/extension.c:2881"
reproduced: false
---

# `%s can only be called from an SQL script executed by CREATE EXTENSION`

## What it means

A function that only makes sense while an extension is being installed was called from outside that context. The placeholder is the function name. Functions such as the ones that mark configuration tables run only inside an extension's setup script.

## When it happens

It occurs when calling a function like `pg_extension_config_dump` directly from a session rather than from within an extension's SQL script during `CREATE EXTENSION` or `ALTER EXTENSION UPDATE`.

## How to fix

Call the function only from an extension's installation or update script. If you are authoring an extension, place the call in its SQL script; if you are a user, this function is not meant to be called interactively.

## Example

*Illustrative* — an extension-only function called directly.

```sql
SELECT pg_extension_config_dump('my_table', '');
```

## Related

- [cannot add an object of this type to an extension](./cannot-add-an-object-of-this-type-to-an-extension.md)
- [can only be executed as a top-level statement](./can-only-be-executed-as-a-top-level-statement.md)
