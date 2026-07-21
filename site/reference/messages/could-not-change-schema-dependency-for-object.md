---
message: "could not change schema dependency for object %u"
slug: could-not-change-schema-dependency-for-object
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/alter.c:820"
reproduced: false
---

# `could not change schema dependency for object %u`

## What it means

An internal step that updates an object's schema dependency during a `SET SCHEMA` operation could not find or update the expected `pg_depend` record. This is a catalog-consistency check.

## When it happens

It fires from generic `ALTER ... SET SCHEMA` handling when the dependency entry it expects to rewrite is missing or in an unexpected state.

## How to fix

This is an internal error that may reflect catalog inconsistency. Record the object and operation, inspect its dependencies, and report it if it recurs on an otherwise healthy catalog. Do not edit `pg_depend` by hand.

## Example

*Illustrative* — a failed object schema-dependency update.

```text
ERROR:  could not change schema dependency for object 16500
```

## Related

- [could not change schema dependency for extension](./could-not-change-schema-dependency-for-extension.md)
- [could not change schema dependency for type](./could-not-change-schema-dependency-for-type.md)
