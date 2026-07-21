---
message: "type \"%s\" already exists"
slug: type-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/catalog/heap.c:1211"
  - "postgres/src/backend/catalog/pg_type.c:430"
  - "postgres/src/backend/catalog/pg_type.c:801"
  - "postgres/src/backend/catalog/pg_type.c:973"
  - "postgres/src/backend/commands/typecmds.c:253"
  - "postgres/src/backend/commands/typecmds.c:265"
  - "postgres/src/backend/commands/typecmds.c:758"
  - "postgres/src/backend/commands/typecmds.c:1213"
  - "postgres/src/backend/commands/typecmds.c:1444"
  - "postgres/src/backend/commands/typecmds.c:1631"
  - "postgres/src/backend/commands/typecmds.c:2624"
reproduced: false
---

# `type "%s" already exists`

## What it means

A `CREATE TYPE` (or a command that implicitly creates a type, such as `CREATE TABLE`, which makes a composite type of the same name) tried to create a type whose name is already taken in the schema. The placeholder is the type name.

## When it happens

Re-running a `CREATE TYPE`, creating a table or composite whose name collides with an existing type, or a name clash between a type and the implicit row type of an existing table (a table and a type share the same namespace).

## How to fix

Choose a different name, or drop the existing type first if it is truly obsolete (`DROP TYPE name`). Remember that every table has an implicit composite type of its name, so a type cannot share a name with a table in the same schema. Use `CREATE TYPE IF NOT EXISTS` where supported, or check `pg_type` before creating.

## Example

*Illustrative* — creating a type whose name is taken.

```sql
CREATE TYPE color AS ENUM ('r','g','b');
CREATE TYPE color AS ENUM ('x');
```

Produces:

```text
ERROR:  type "color" already exists
```

## Related

- [type %s does not exist](./type-does-not-exist-34f5c8.md)
- [relation already exists](./relation-already-exists.md)
