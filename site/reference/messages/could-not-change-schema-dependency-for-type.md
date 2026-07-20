---
message: "could not change schema dependency for type \"%s\""
slug: could-not-change-schema-dependency-for-type
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/typecmds.c:4321"
reproduced: false
---

# `could not change schema dependency for type "%s"`

## What it means

An internal step that updates a type's schema dependency during `ALTER TYPE ... SET SCHEMA` (or a related move) could not find or update the expected `pg_depend` record. This is a catalog-consistency check.

## When it happens

It fires when moving a type to a new schema and its namespace-dependency entry is not in the expected state.

## How to fix

This is an internal error that may indicate catalog inconsistency. Record the type and operation, inspect its dependencies, and report it if it recurs on a healthy catalog. Do not modify `pg_depend` directly.

## Example

*Illustrative* — a failed type schema-dependency update.

```text
ERROR:  could not change schema dependency for type "mytype"
```

## Related

- [could not change schema dependency for relation](./could-not-change-schema-dependency-for-relation.md)
- [could not change support dependency for function](./could-not-change-support-dependency-for-function.md)
