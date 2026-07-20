---
message: "extension \"%s\" already exists"
slug: extension-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/commands/extension.c:2179"
reproduced: false
---

# `extension "%s" already exists`

## What it means

A `CREATE EXTENSION` named an extension that is already installed in the current database. The placeholder is the extension name. Extension names are unique per database.

## When it happens

It fires from `CREATE EXTENSION name` when that extension is already present, often when re-running an install script.

## How to fix

Use `CREATE EXTENSION IF NOT EXISTS name` to make the install idempotent, or check `pg_extension` first. If you meant to change its version, use `ALTER EXTENSION name UPDATE`. To reinstall, `DROP EXTENSION name` first (mind dependent objects).

## Example

*Illustrative* — guard the install to avoid the error.

```sql
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```

## Related

- [extension is not available](./extension-is-not-available.md)
- [extension must be installed in schema](./extension-must-be-installed-in-schema.md)
