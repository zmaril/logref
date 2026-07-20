---
message: "invalid extension name: \"%s\""
slug: invalid-extension-name
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/extension.c:410"
  - "postgres/src/backend/commands/extension.c:419"
  - "postgres/src/backend/commands/extension.c:431"
  - "postgres/src/backend/commands/extension.c:441"
reproduced: false
---

# `invalid extension name: "%s"`

## What it means

An extension name given to a command is not a syntactically valid extension name. The placeholder is the name. Extension names must be valid identifiers without characters like directory separators, since they map to control/script filenames.

## When it happens

Running `CREATE EXTENSION`/`ALTER EXTENSION` with a name containing illegal characters (slashes, dots used unsafely) or otherwise not a valid identifier.

## How to fix

Use a valid extension name — a plain identifier matching an installed extension's control file. List available extensions with `SELECT name FROM pg_available_extensions`. Correct typos and remove any path-like characters.

## Example

*Illustrative* — an invalid extension name.

```sql
CREATE EXTENSION "../evil";
```

## Related

- [invalid extension version name](./invalid-extension-version-name.md)
- [string is not a valid identifier](./string-is-not-a-valid-identifier.md)
