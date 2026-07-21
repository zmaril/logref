---
message: "parameter \"%s\" cannot be set in a secondary extension control file"
slug: parameter-cannot-be-set-in-a-secondary-extension-control-file
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_SYNTAX_ERROR
    code: "42601"
call_sites:
  - "postgres/src/backend/commands/extension.c:768"
  - "postgres/src/backend/commands/extension.c:778"
reproduced: false
---

# `parameter "%s" cannot be set in a secondary extension control file`

## What it means

An extension's secondary (version-specific) control file set a parameter that is only allowed in the extension's primary control file. The placeholder names the parameter. Certain control-file directives must appear only once, in the main file.

## When it happens

It arises while `CREATE EXTENSION` or `ALTER EXTENSION` reads a `name--version.control` file that contains a directive reserved for the top-level `name.control`.

## How to fix

Move the offending directive out of the version-specific control file and into the extension's primary control file. This is an extension-packaging fix for the extension author, not something a database user configures.

## Example

*Illustrative* — a version control file setting a primary-only parameter.

```text
ERROR:  parameter "schema" cannot be set in a secondary extension control file
```

## Related

- [parameter "%s" cannot be changed](./parameter-cannot-be-changed.md)
- [parameter name "%s" used more than once](./parameter-name-used-more-than-once.md)
