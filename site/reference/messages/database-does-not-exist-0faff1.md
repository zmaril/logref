---
message: "database \"%s\" does not exist"
slug: database-does-not-exist-0faff1
passthrough: false
api: [ereport]
level: [FATAL, WARNING]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_DATABASE
    code: "3D000"
call_sites:
  - "postgres/src/backend/commands/comment.c:60"
  - "postgres/src/backend/utils/init/postinit.c:1065"
  - "postgres/src/backend/utils/init/postinit.c:1129"
  - "postgres/src/backend/utils/init/postinit.c:1202"
reproduced: true
---

# `database "%s" does not exist`

## What it means

A command referenced a database by name that does not exist in the cluster. The placeholder is the database name. Databases live in `pg_database`; naming one that was never created or has been dropped produces this. At `WARNING` it is a non-fatal variant (for example commenting on a missing target).

## When it happens

Connecting to, commenting on, altering, or dropping a database whose name is misspelled, was already dropped, or never existed.

## How to fix

List databases with `\l` in psql or `SELECT datname FROM pg_database`. Correct the name, create the database with `CREATE DATABASE`, or use `IF EXISTS` on a `DROP` when a missing database should be tolerated.

## Example

*Reproduced* — captured from `reproducers/scenarios/28_typecmds_domain_comment.sql`.

```sql
COMMENT ON DATABASE nonexistent_db IS 'x';
```

Produces:

```text
WARNING:  database "nonexistent_db" does not exist
```

## Related

- [cross-database references are not implemented](./cross-database-references-are-not-implemented-215494.md)
- [tablespace does not exist](./tablespace-does-not-exist.md)
