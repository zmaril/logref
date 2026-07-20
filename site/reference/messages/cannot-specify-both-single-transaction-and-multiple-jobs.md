---
message: "cannot specify both --single-transaction and multiple jobs"
slug: cannot-specify-both-single-transaction-and-multiple-jobs
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_dump/pg_restore.c:433"
reproduced: false
---

# `cannot specify both --single-transaction and multiple jobs`

## What it means

A restore was asked to run inside a single transaction and to use more than one parallel job. Parallel restore opens several connections, which cannot share one transaction, so the two options conflict.

## When it happens

It happens with `pg_restore` when `--single-transaction` (`-1`) is combined with `--jobs` (`-j`) greater than one.

## How to fix

Pick one behavior. Drop `--jobs` to restore in a single transaction, or drop `--single-transaction` to restore in parallel.

## Example

*Illustrative* — single transaction with parallel jobs.

```text
pg_restore: error: cannot specify both --single-transaction and multiple jobs
```

## Related

- [cannot specify both a database name and database patterns](./cannot-specify-both-a-database-name-and-database-patterns.md)
- [cannot use multiple jobs to reindex system catalogs](./cannot-use-multiple-jobs-to-reindex-system-catalogs.md)
