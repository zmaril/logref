---
message: "extension should not have a sub-object dependency"
slug: extension-should-not-have-a-sub-object-dependency
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/extension.c:3419"
reproduced: false
---

# `extension should not have a sub-object dependency`

## What it means

An internal consistency check in extension dependency handling. It found a dependency recorded against a sub-object (like a specific column) of an extension member, which the extension model does not expect. It is a catalog-shape invariant.

## When it happens

It fires while the server processes extension membership or dependencies if a dependency points at a sub-object rather than a whole object. In normal operation extension dependencies are recorded at the object level.

## How to fix

This is an internal invariant, not a user action. It usually points at inconsistent dependency records, possibly from a buggy extension script or manual catalog changes. Confirm the catalogs were not edited directly. Capture the extension and the operation and report it if the objects were created through normal DDL.

## Example

*Illustrative* — the message as logged.

```
ERROR:  extension should not have a sub-object dependency
```

## Related

- [extversion is null](./extversion-is-null.md)
- [extension has no update path from version to version](./extension-has-no-update-path-from-version-to-version.md)
