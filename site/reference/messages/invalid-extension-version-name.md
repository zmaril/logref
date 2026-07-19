---
message: "invalid extension version name: \"%s\""
slug: invalid-extension-version-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/extension.c:457"
  - "postgres/src/backend/commands/extension.c:466"
  - "postgres/src/backend/commands/extension.c:475"
  - "postgres/src/backend/commands/extension.c:485"
reproduced: false
---

# `invalid extension version name: "%s"`

## What it means

An extension version string is not valid. The placeholder is the version. Extension versions map to script filenames, so they may not contain characters like directory separators or `--`, and must be non-empty.

## When it happens

Running `CREATE EXTENSION ... VERSION`/`ALTER EXTENSION ... UPDATE TO` with a version string containing illegal characters, or an extension whose control file declares a malformed default version.

## How to fix

Use a valid version string that corresponds to an installed extension script (for example `1.2`). Avoid path separators and `--`. List installed versions with `SELECT * FROM pg_available_extension_versions`, and pick one that exists.

## Example

*Illustrative* — an invalid version string.

```sql
ALTER EXTENSION hstore UPDATE TO '1/2';
```

## Related

- [invalid extension name](./invalid-extension-name.md)
- [string is not a valid identifier](./string-is-not-a-valid-identifier.md)
