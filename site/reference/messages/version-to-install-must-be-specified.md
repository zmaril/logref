---
message: "version to install must be specified"
slug: version-to-install-must-be-specified
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/extension.c:1872"
  - "postgres/src/backend/commands/extension.c:3573"
reproduced: false
---

# `version to install must be specified`

## What it means

An operation that installs a specific extension version was invoked without a version, and no default version could be determined.

## When it happens

It arises from `CREATE EXTENSION`/`ALTER EXTENSION ... UPDATE` (or the extension-install machinery) when no `VERSION` was given and the control file does not name a default version to fall back on.

## How to fix

Name the version explicitly with `VERSION '<v>'`, or set a `default_version` in the extension's control file. The available versions appear in `pg_available_extension_versions`.

## Example

*Illustrative* — installing without a version.

```text
ERROR:  version to install must be specified
```

## Related

- [value %s out of bounds for option "%s"](./value-out-of-bounds-for-option.md)
- [wait event "%s" already exists in type "%s"](./wait-event-already-exists-in-type.md)
