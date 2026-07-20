---
message: "incorrect number of output arguments"
slug: incorrect-number-of-output-arguments
passthrough: false
api: [elog]
level: [ERROR]
call_sites:
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:108"
  - "postgres/contrib/pg_buffercache/pg_buffercache_pages.c:397"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:1705"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:1710"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:1715"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:1719"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:1723"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:1727"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:1731"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:1735"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:1739"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:1743"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:1746"
  - "postgres/contrib/pgstattuple/pgstatapprox.c:321"
  - "postgres/contrib/postgres_fdw/connection.c:2326"
  - "postgres/contrib/postgres_fdw/connection.c:2330"
  - "postgres/contrib/postgres_fdw/connection.c:2333"
reproduced: false
---

# `incorrect number of output arguments`

## What it means

A function that returns a record was called with a column definition (or an expected tuple descriptor) whose number of columns does not match what the function actually produces. The caller's declared output shape and the function's real output disagree.

## When it happens

Common with set-returning contrib functions (`pg_stat_statements`, `pg_buffercache`, `dblink`, `pgstatapprox`) after a version change altered the function's output columns, but the SQL wrapper or the caller's `AS (...)` list still uses the old shape. Also when hand-writing a column list that has the wrong number of entries.

## How to fix

Match the column definition list to the function's current output columns. If this appeared after upgrading an extension, run `ALTER EXTENSION ... UPDATE` so its SQL definitions match the new binary, and update any hand-written `AS (col ...)` lists. Check the function's documentation for the exact output columns in your version.

## Example

*Illustrative* — a stale column list after an extension upgrade.

```text
ERROR:  incorrect number of output arguments
```

## Related

- [return type must be a row type](./return-type-must-be-a-row-type.md)
- [table row type and query-specified row type do not match](./table-row-type-and-query-specified-row-type-do-not-match.md)
