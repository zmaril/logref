---
message: "cross-database references are not implemented: \"%s.%s.%s\""
slug: cross-database-references-are-not-implemented-215494
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:461"
  - "postgres/src/backend/catalog/namespace.c:665"
  - "postgres/src/backend/catalog/namespace.c:757"
  - "postgres/src/backend/commands/trigger.c:5920"
reproduced: true
---

# `cross-database references are not implemented: "%s.%s.%s"`

## What it means

A statement used a fully three-part name (`database.schema.object`) whose database part is not the current one. The placeholders are the three name components. A Postgres session operates within a single database and cannot reach objects in another by qualified name.

## When it happens

Writing `db.schema.table` where `db` differs from the connected database — common for users migrating from systems where one connection spans multiple databases.

## How to fix

Connect directly to the target database, or use `postgres_fdw`/`dblink` to expose the remote objects locally. Within one database, use two-part `schema.object` names; the database qualifier is only accepted when it names the current database.

## Example

*Reproduced* — captured from `reproducers/scenarios/35_ddl_object_lifecycle.sql`.

```sql
CREATE TABLE nosuchdb.public.t (a int);
```

Produces:

```text
ERROR:  cross-database references are not implemented: "nosuchdb.public.t"
```

## Related

- [cross-database references are not implemented](./cross-database-references-are-not-implemented-715b74.md)
- [database does not exist](./database-does-not-exist-0faff1.md)
