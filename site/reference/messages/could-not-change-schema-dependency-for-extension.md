---
message: "could not change schema dependency for extension %s"
slug: could-not-change-schema-dependency-for-extension
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/extension.c:3459"
reproduced: false
---

# `could not change schema dependency for extension %s`

## What it means

An internal step that updates the schema dependency of an extension failed to find or update the expected dependency record. This is a catalog-consistency check during `ALTER EXTENSION ... SET SCHEMA`.

## When it happens

It fires when moving an extension to a new schema and the `pg_depend` entry it expects to rewrite is not in the expected state.

## How to fix

This is an internal error that can indicate catalog inconsistency. Note the extension and operation, inspect its dependencies, and report it if it recurs on a healthy catalog. Avoid manual edits to `pg_depend`.

## Example

*Illustrative* — a failed extension schema-dependency update.

```text
ERROR:  could not change schema dependency for extension myext
```

## Related

- [could not change schema dependency for object](./could-not-change-schema-dependency-for-object.md)
- [could not change schema dependency for relation](./could-not-change-schema-dependency-for-relation.md)
