---
message: "foreign-data wrapper \"%s\" does not exist"
slug: foreign-data-wrapper-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/foreigncmds.c:300"
  - "postgres/src/backend/commands/foreigncmds.c:769"
  - "postgres/src/backend/foreign/foreign.c:721"
reproduced: true
---

# `foreign-data wrapper "%s" does not exist`

## What it means

A command referenced a foreign-data wrapper (FDW) by name that does not exist. The placeholder is the name. An FDW is the driver behind foreign servers and tables; creating a server or altering an FDW that is not installed cannot resolve.

## When it happens

`CREATE SERVER ... FOREIGN DATA WRAPPER x`, `ALTER`/`DROP FOREIGN DATA WRAPPER x`, where `x` is misspelled or its extension (for example `postgres_fdw`, `file_fdw`) has not been installed with `CREATE EXTENSION`.

## How to fix

Install the wrapper's extension first (`CREATE EXTENSION postgres_fdw`), or use the correct name — `\dew` (or `SELECT fdwname FROM pg_foreign_data_wrapper`) lists installed wrappers. Then create the server against the existing FDW.

## Example

*Reproduced* — captured from `reproducers/scenarios/25_ddl_objects_more.sql`.

```sql
CREATE SERVER srv FOREIGN DATA WRAPPER nosuchfdw;
```

Produces:

```text
ERROR:  foreign-data wrapper "nosuchfdw" does not exist
```

## Related

- [cache lookup failed for foreign table](./cache-lookup-failed-for-foreign-table.md)
- [event trigger does not exist](./event-trigger-does-not-exist.md)
