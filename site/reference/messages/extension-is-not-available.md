---
message: "extension \"%s\" is not available"
slug: extension-is-not-available
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/extension.c:722"
reproduced: false
---

# `extension "%s" is not available`

## What it means

A `CREATE EXTENSION` named an extension whose control file is not installed on the server. The placeholder is the extension name. PostgreSQL can only create extensions whose files are present in the installation's extension directory.

## When it happens

It fires from `CREATE EXTENSION name` when the server cannot find `name.control` — usually because the extension's package (often a `-contrib` or third-party package) is not installed on the host, or is installed for a different PostgreSQL version.

## How to fix

Install the operating-system package that provides the extension for this server's major version (for example the `contrib` package for built-in extensions, or the vendor package for third-party ones). Confirm the files land in the running server's extension directory. Then re-run `CREATE EXTENSION`. `pg_available_extensions` lists what is installed and creatable.

## Example

*Illustrative* — check what is available first.

```sql
SELECT name FROM pg_available_extensions WHERE name = 'pg_trgm';
```

## Related

- [extension already exists](./extension-already-exists.md)
- [extension must be installed in schema](./extension-must-be-installed-in-schema.md)
