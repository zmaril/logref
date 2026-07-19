---
message: "could not change schema dependency for relation \"%s\""
slug: could-not-change-schema-dependency-for-relation
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/src/backend/commands/tablecmds.c:19812"
reproduced: false
---

# `could not change schema dependency for relation "%s"`

## What it means

An internal step that updates a relation's schema dependency during `ALTER TABLE ... SET SCHEMA` (or a related move) could not find or update the expected `pg_depend` record. This is a catalog-consistency check.

## When it happens

It fires when moving a relation to a new schema and its namespace-dependency entry is not in the expected state.

## How to fix

This is an internal error signaling possible catalog inconsistency. Note the relation and operation, inspect its dependencies, and report it if it recurs on a healthy catalog. Avoid manual `pg_depend` edits.

## Example

*Illustrative* — a failed relation schema-dependency update.

```text
ERROR:  could not change schema dependency for relation "t"
```

## Related

- [could not change schema dependency for object](./could-not-change-schema-dependency-for-object.md)
- [could not change schema dependency for type](./could-not-change-schema-dependency-for-type.md)
