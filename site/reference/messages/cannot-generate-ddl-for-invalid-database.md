---
message: "cannot generate DDL for invalid database \"%s\""
slug: cannot-generate-ddl-for-invalid-database
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/src/backend/utils/adt/ddlutils.c:693"
reproduced: false
---

# `cannot generate DDL for invalid database "%s"`

## What it means

A request to generate DDL for a database was refused because the database is marked invalid. A database is flagged invalid when a `CREATE DATABASE` or `DROP DATABASE` was interrupted, leaving it in a half-created or half-dropped state. The placeholder is the database name.

## When it happens

It occurs when a DDL-generation function or tool is pointed at a database whose `pg_database.datconnlimit` marks it invalid after a failed create or drop.

## How to fix

Finish cleaning up the invalid database: `DROP DATABASE` it (Postgres allows dropping an invalid database) and recreate it if needed. Once a valid database exists, generate its DDL.

## Example

*Illustrative* — DDL requested for an invalid database.

```text
ERROR:  cannot generate DDL for invalid database "olddb"
```

## Related

- [cannot generate a manifest because no manifest is available for the final input backup](./cannot-generate-a-manifest-because-no-manifest-is-available-for-the-final-input.md)
- [cannot execute in this configuration](./cannot-execute-in-this-configuration.md)
