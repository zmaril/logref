---
message: "extension \"%s\" has no installation script nor update path for version \"%s\""
slug: extension-has-no-installation-script-nor-update-path-for-version
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/extension.c:1909"
reproduced: true
---

# `extension "%s" has no installation script nor update path for version "%s"`

## What it means

A `CREATE EXTENSION ... VERSION` or update asked for a version that the extension's installed control and script files cannot produce — there is neither a direct install script for it nor an update path leading to it. The placeholders are the extension name and requested version.

## When it happens

It fires from `CREATE EXTENSION name VERSION 'x'` or `ALTER EXTENSION name UPDATE TO 'x'` when version `x` has no matching SQL script and no chain of update scripts reaching it in the extension's install directory.

## How to fix

List the versions the installed files support by checking `pg_available_extension_versions`, and request one of those. If you need the missing version, install the extension package that ships its script files. The requested version must be reachable from what is on disk.

## Example

*Reproduced* — captured from `reproducers/scenarios/29_func_index_extension_ddl.sql`.

```sql
CREATE EXTENSION amcheck VERSION 'nonexistent_version';
```

Produces:

```text
ERROR:  extension "amcheck" has no installation script nor update path for version "nonexistent_version"
```

## Related

- [extension has no update path from version to version](./extension-has-no-update-path-from-version-to-version.md)
- [extension is not available](./extension-is-not-available.md)
