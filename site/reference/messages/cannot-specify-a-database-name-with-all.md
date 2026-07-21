---
message: "cannot specify a database name with --all"
slug: cannot-specify-a-database-name-with-all
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:487"
reproduced: false
---

# `cannot specify a database name with --all`

## What it means

A utility program was given both the all-databases option and a specific database name. These targets conflict, so the command cannot proceed.

## When it happens

It occurs when a tool such as `pg_amcheck` or a scripts utility is invoked with `--all` together with a database name.

## How to fix

Choose one scope: use `--all` for every database, or name a single database without `--all`. Run separate invocations if you need both.

## Example

*Illustrative* — --all combined with a database name.

```text
pg_amcheck: error: cannot specify a database name with --all
```

## Related

- [cannot reindex all databases and a specific one at the same time](./cannot-reindex-all-databases-and-a-specific-one-at-the-same-time.md)
- [cannot run pg_upgrade from inside the new cluster data directory on Windows](./cannot-run-pg-upgrade-from-inside-the-new-cluster-data-directory-on-windows.md)
