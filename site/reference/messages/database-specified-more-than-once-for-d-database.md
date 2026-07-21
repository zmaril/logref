---
message: "database \"%s\" specified more than once for -d/--database"
slug: database-specified-more-than-once-for-d-database
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2345"
reproduced: false
---

# `database "%s" specified more than once for -d/--database`

## What it means

`pg_createsubscriber` was given the same database name more than once with the `-d`/`--database` option. The placeholder is the database name. Each database should be listed at most once.

## When it happens

It happens when you pass `-d name` (or `--database=name`) two or more times for the same database on the `pg_createsubscriber` command line.

## How to fix

List each database only once. Remove the duplicate `-d`/`--database` option and rerun. If you meant several different databases, make sure each name is distinct.

## Example

*Illustrative* — a repeated database option.

```text
pg_createsubscriber: error: database "app" specified more than once for -d/--database
```

## Related

- [database creation failed](./database-creation-failed.md)
- [could not reset WAL on subscriber](./could-not-reset-wal-on-subscriber.md)
