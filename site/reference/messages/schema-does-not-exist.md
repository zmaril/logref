---
message: "schema \"%s\" does not exist"
slug: schema-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_SCHEMA
    code: "3F000"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:3614"
  - "postgres/src/backend/commands/schemacmds.c:263"
  - "postgres/src/backend/commands/schemacmds.c:343"
  - "postgres/src/backend/commands/tablecmds.c:1531"
reproduced: false
---

# `schema "%s" does not exist`

## What it means

A command referenced a schema by name that does not exist in the current database. The placeholder is the name. Schemas are the namespaces that hold tables, functions, and other objects; naming a missing one — in a qualified object name, a `SET search_path`, or a schema-level command — cannot be resolved.

## When it happens

Using `schema.object` where the schema is misspelled or was never created, `SET search_path TO x` with a nonexistent `x`, or `ALTER`/`DROP SCHEMA` on a name that is not present.

## How to fix

List schemas with `\dn` (or `SELECT nspname FROM pg_namespace`) and use the correct name, or create it with `CREATE SCHEMA`. Schemas are per-database, so make sure you are connected to the right database. Watch for case: an identifier created with quotes preserves its case.

## Example

*Illustrative* — referencing a missing schema.

```sql
SELECT * FROM reporting.sales;  -- schema "reporting" does not exist
```

## Related

- [no schema has been selected to create in](./no-schema-has-been-selected-to-create-in.md)
- [schema with OID does not exist](./schema-with-oid-does-not-exist.md)
