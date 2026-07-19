---
message: "pg_stat_statements must be loaded via \"shared_preload_libraries\""
slug: pg-stat-statements-must-be-loaded-via-shared-preload-libraries
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_NOT_IN_PREREQUISITE_STATE
    code: "55000"
call_sites:
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:1690"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:2045"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:2690"
reproduced: false
---

# `pg_stat_statements must be loaded via "shared_preload_libraries"`

## What it means

The `pg_stat_statements` extension was used before its shared library was loaded at server start. The extension hooks into query execution and must be preloaded, so its functions and view do not work if it was not loaded that way.

## When it happens

Running `CREATE EXTENSION pg_stat_statements` or querying its view when `pg_stat_statements` is not listed in `shared_preload_libraries`, or after adding it to the setting without restarting the server.

## How to fix

Add `pg_stat_statements` to `shared_preload_libraries` in `postgresql.conf` and restart the server, then create the extension. Because the library only loads at startup, a configuration reload is not enough; a full restart is required.

## Example

*Illustrative* — using the extension without preloading it.

```sql
SELECT * FROM pg_stat_statements;  -- must be loaded via shared_preload_libraries
```

## Related

- [could not access file](./could-not-access-file.md)
- [invalid value for option](./invalid-value-for-option.md)
