---
message: "extension \"%s\" has no update path from version \"%s\" to version \"%s\""
slug: extension-has-no-update-path-from-version-to-version
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/extension.c:1664"
reproduced: false
---

# `extension "%s" has no update path from version "%s" to version "%s"`

## What it means

An `ALTER EXTENSION ... UPDATE` asked to move from the currently installed version to a target version, but the extension's update scripts do not form a path between them. The placeholders are the extension name and the from and to versions.

## When it happens

It fires from `ALTER EXTENSION name UPDATE TO 'y'` when no sequence of update scripts connects the installed version to `y` in the extension's install directory.

## How to fix

Install the extension package that provides the intermediate update scripts, so a path exists from your current version to the target. Check the available versions and paths from `pg_available_extension_versions` and the extension's control files. In some cases you must update through intermediate versions in steps.

## Example

*Illustrative* — update toward a reachable version.

```sql
ALTER EXTENSION myext UPDATE TO '1.2';
```

## Related

- [extension has no installation script nor update path for version](./extension-has-no-installation-script-nor-update-path-for-version.md)
- [extension already exists](./extension-already-exists.md)
