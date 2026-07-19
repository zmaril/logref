---
message: "extversion is null"
slug: extversion-is-null
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/extension.c:3528"
reproduced: false
---

# `extversion is null`

## What it means

An internal guard. Reading an extension's row from `pg_extension`, the server found a null in the `extversion` column, which must always hold the installed version string. It is a catalog-shape invariant.

## When it happens

It fires while the server reads extension metadata if the version column is null. In a healthy catalog every extension row has a version, so this cannot normally happen.

## How to fix

This points at catalog inconsistency or a manually altered `pg_extension` row, not a user mistake. Confirm nobody edited the system catalogs directly. Dropping and recreating the affected extension usually restores a consistent row. Capture the details and report it if the extension was managed only through normal DDL.

## Example

*Illustrative* — the message as logged.

```
ERROR:  extversion is null
```

## Related

- [extension should not have a sub-object dependency](./extension-should-not-have-a-sub-object-dependency.md)
- [extension already exists](./extension-already-exists.md)
