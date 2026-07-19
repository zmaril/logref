---
message: "query failed: %s"
slug: query-failed
passthrough: false
api: [pg_log_error]
level: [ERROR]
call_sites:
  - "postgres/contrib/oid2name/oid2name.c:390"
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:1695"
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:2155"
  - "postgres/src/bin/pg_dump/connectdb.c:288"
  - "postgres/src/bin/pg_dump/pg_backup_db.c:212"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:1784"
  - "postgres/src/bin/pgbench/pgbench.c:873"
  - "postgres/src/bin/pgbench/pgbench.c:1502"
  - "postgres/src/fe_utils/query_utils.c:33"
  - "postgres/src/fe_utils/query_utils.c:58"
reproduced: false
---

# `query failed: %s`

## What it means

A client tool ran a SQL query internally and it failed; the placeholder is the server's error text. Utilities like `oid2name`, `pg_amcheck`, `vacuumlo`, and `pg_dump` issue their own queries, and when one fails they report it with this prefix followed by the server error.

## When it happens

The tool's internal query hit a server-side error — a missing object, insufficient privileges, a connection drop, or a version mismatch where the tool queried a catalog the server does not have. The embedded server error is the real cause.

## How to fix

Read the server error text after the colon — it is the actual diagnosis. Common causes: the connecting role lacks privileges the tool needs, or the tool version does not match the server (its catalog queries assume a different schema). Grant the needed rights or use a matching tool version.

## Example

*Illustrative* — an internal tool query hitting a permissions error.

```text
pg_amcheck: error: query failed: ERROR:  permission denied for table pg_class
```

## Related

- [Query was: %s](./query-was.md)
- [query failed: %m](./could-not-execute-command.md)
