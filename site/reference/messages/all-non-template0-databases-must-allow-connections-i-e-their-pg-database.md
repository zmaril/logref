---
message: "All non-template0 databases must allow connections, i.e. their\npg_database.datallowconn must be true and pg_database.datconnlimit\nmust not be -2.  Your installation contains non-template0 databases\nwhich cannot be connected to.  Consider allowing connection for all\nnon-template0 databases or drop the databases which do not allow\nconnections.  A list of databases with the problem is in the file:\n    %s"
slug: all-non-template0-databases-must-allow-connections-i-e-their-pg-database
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_upgrade/check.c:1142"
reproduced: false
---

# `All non-template0 databases must allow connections, i.e. their
pg_database.datallowconn must be true and pg_database.datconnlimit
must not be -2.  Your installation contains non-template0 databases
which cannot be connected to.  Consider allowing connection for all
non-template0 databases or drop the databases which do not allow
connections.  A list of databases with the problem is in the file:
    %s`

## What it means

A tool that must connect to every database (such as `pg_upgrade` or a global operation) found databases other than `template0` that forbid connections, so it cannot process them.

## When it happens

It is raised as fatal when one or more databases have `datallowconn = false` (or a `datconnlimit` of -2) and the operation requires connecting to all non-`template0` databases.

## How to fix

Allow connections to the affected databases before running the operation: `ALTER DATABASE dbname WITH ALLOW_CONNECTIONS true` (and fix any `-2` connection limit). The message names a file listing the problem databases. Re-run the operation once every non-`template0` database permits connections, then restore any intended restrictions afterward.

## Example

*Illustrative* — a database that disallows connections blocking a global operation.

```text
FATAL:  All non-template0 databases must allow connections ...
```

## Related

- [already connected to a database](./already-connected-to-a-database.md)
- [archive format is not supported; please use psql](./archive-format-is-not-supported-please-use-psql.md)
