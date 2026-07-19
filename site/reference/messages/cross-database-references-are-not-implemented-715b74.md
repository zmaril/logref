---
message: "cross-database references are not implemented: %s"
slug: cross-database-references-are-not-implemented-715b74
passthrough: false
api: [ereport, pg_fatal, pg_log_error]
level: [ERROR, FATAL]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/catalog/namespace.c:3399"
  - "postgres/src/backend/parser/parse_expr.c:881"
  - "postgres/src/backend/parser/parse_target.c:1265"
  - "postgres/src/bin/pg_dump/pg_dump.c:1907"
  - "postgres/src/bin/psql/describe.c:6461"
reproduced: false
---

# `cross-database references are not implemented: %s`

## What it means

A statement tried to reach an object in a different database than the current session's. The placeholder is the qualified name. A Postgres session is bound to one database; three-part names that cross databases are not supported. This variant carries a single qualified string.

## When it happens

Referencing `otherdb.schema.table` in SQL, or a tool constructing such a reference. Users coming from systems where one connection spans multiple databases hit this often.

## How to fix

Connect directly to the target database instead of qualifying across databases. To combine data from two databases in one query, use `postgres_fdw` (or `dblink`) to expose the remote objects as foreign tables in the current database.

## Example

*Illustrative* — a cross-database reference.

```sql
SELECT * FROM otherdb.public.t;
```

## Related

- [cross-database references are not implemented](./cross-database-references-are-not-implemented-215494.md)
- [database does not exist](./database-does-not-exist-0faff1.md)
