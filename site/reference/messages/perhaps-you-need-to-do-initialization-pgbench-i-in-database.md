---
message: "Perhaps you need to do initialization (\"pgbench -i\") in database \"%s\"."
slug: perhaps-you-need-to-do-initialization-pgbench-i-in-database
passthrough: false
api: [pg_log_error_hint]
level: [ERROR]
call_sites:
  - "postgres/src/bin/pgbench/pgbench.c:5427"
  - "postgres/src/bin/pgbench/pgbench.c:5483"
reproduced: false
---

# `Perhaps you need to do initialization ("pgbench -i") in database "%s".`

## What it means

A hint from `pgbench`. It ran against a database that does not contain the standard benchmark tables, and suggests initializing the schema first. The placeholder is the database name.

## When it happens

It appears when `pgbench` is run without `-i` against a fresh database, so the `pgbench_accounts`/`pgbench_branches`/`pgbench_tellers`/`pgbench_history` tables the default script expects are missing.

## How to fix

Run the initialization step first: `pgbench -i [-s scale] dbname` creates and populates the benchmark tables. Then run the benchmark proper. If you use a custom script (`-f`) that does not need those tables, this hint does not apply.

## Example

*Illustrative* — running the benchmark before initializing it.

```text
ERROR:  relation "pgbench_branches" does not exist
HINT:  Perhaps you need to do initialization ("pgbench -i") in database "bench".
```

## Related

- [transaction ID (-c) must be either %u or greater than or equal to %u](./transaction-id-c-must-be-either-or-greater-than-or-equal-to.md)
- [query returned no rows](./query-returned-no-rows.md)
