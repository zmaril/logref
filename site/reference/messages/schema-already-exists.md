---
message: "schema \"%s\" already exists"
slug: schema-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_SCHEMA
    code: "42P06"
call_sites:
  - "postgres/src/backend/catalog/pg_namespace.c:62"
  - "postgres/src/backend/commands/schemacmds.c:272"
reproduced: false
---

# `schema "%s" already exists`

## What it means

A `CREATE SCHEMA` named a schema that already exists. The placeholder is the schema name. Schema names must be unique within a database.

## When it happens

It arises when creating a schema whose name is already present — a re-run migration, or a collision with an existing schema.

## How to fix

Use `CREATE SCHEMA IF NOT EXISTS` for idempotent creation, choose a different name, or drop the existing schema first if you genuinely mean to replace it (`DROP SCHEMA name CASCADE` removes its contents too).

## Example

*Illustrative* — creating a schema that already exists.

```text
ERROR:  schema "reporting" already exists
```

## Related

- [unacceptable schema name "%s"](./unacceptable-schema-name.md)
- [tablespace "%s" already exists](./tablespace-already-exists.md)
