---
message: "cannot specify both a database name and database patterns"
slug: cannot-specify-both-a-database-name-and-database-patterns
passthrough: false
api: [pg_fatal]
level: [FATAL]
call_sites:
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:493"
reproduced: false
---

# `cannot specify both a database name and database patterns`

## What it means

A dump or restore command was given both an explicit database name and one or more database-pattern options at once. The tool cannot decide whether to operate on the single named database or on the set the patterns match, so it stops.

## When it happens

It happens with `pg_dumpall` or `pg_restore` when a positional database argument is combined with pattern options such as `--exclude-database`, or when database-selection flags conflict on the command line.

## How to fix

Choose one selection method. Pass just the database name to target a single database, or use only the pattern options to select a set. Remove the conflicting argument and rerun.

## Example

*Illustrative* — a name and a pattern given together.

```text
pg_dumpall: error: cannot specify both a database name and database patterns
```

## Related

- [cannot specify both --single-transaction and multiple jobs](./cannot-specify-both-single-transaction-and-multiple-jobs.md)
- [cannot specify both format and backup target](./cannot-specify-both-format-and-backup-target.md)
