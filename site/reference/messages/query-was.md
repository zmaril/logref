---
message: "Query was: %s"
slug: query-was
passthrough: false
api: [pg_log_error_detail, pg_log_warning_detail]
level: [ERROR, WARNING]
call_sites:
  - "postgres/contrib/oid2name/oid2name.c:391"
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:579"
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:1149"
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:1696"
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:2156"
  - "postgres/src/bin/pg_dump/connectdb.c:289"
  - "postgres/src/bin/pg_dump/pg_backup_db.c:214"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:1785"
  - "postgres/src/bin/pgbench/pgbench.c:874"
  - "postgres/src/bin/pgbench/pgbench.c:1503"
  - "postgres/src/fe_utils/query_utils.c:34"
  - "postgres/src/fe_utils/query_utils.c:59"
reproduced: false
---

# `Query was: %s`

## What it means

Not a standalone error — this is a context/detail line appended after another error, echoing the SQL text that failed. The placeholder is the query. Client tools and internal SQL executors (`dblink`, `pg_amcheck`, `pg_dump`) print it so you can see exactly which generated statement triggered the real error above.

## When it happens

Emitted alongside a primary error when a tool runs SQL on your behalf and wants to show the failing statement. It always follows the actual error message, which carries the real diagnosis.

## How to fix

Read the error line above this one — that is the real problem. The `Query was:` text shows the statement the tool sent, which is useful when the SQL was generated rather than written by you. Fix the underlying error; this line is just context to locate it.

## Example

*Illustrative* — a generated statement echoed after its error.

```text
ERROR:  relation "missing" does not exist
Query was: SELECT * FROM missing
```

## Related

- [query failed](./query-failed.md)
- [%s](./msg-347cd9c5.md)
