---
message: "too many command-line arguments (first is \"%s\")"
slug: too-many-command-line-arguments-first-is-c4e086
passthrough: false
api: [pg_fatal, pg_log_error]
level: [ERROR, FATAL]
call_sites:
  - "postgres/contrib/oid2name/oid2name.c:193"
  - "postgres/src/bin/initdb/initdb.c:3449"
  - "postgres/src/bin/pg_amcheck/pg_amcheck.c:467"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2572"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:2444"
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:758"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:873"
  - "postgres/src/bin/pg_checksums/pg_checksums.c:535"
  - "postgres/src/bin/pg_controldata/pg_controldata.c:155"
  - "postgres/src/bin/pg_dump/pg_dump.c:819"
  - "postgres/src/bin/pg_dump/pg_dumpall.c:392"
  - "postgres/src/bin/pg_dump/pg_restore.c:340"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:368"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:268"
  - "postgres/src/bin/pg_test_fsync/pg_test_fsync.c:208"
  - "postgres/src/bin/pg_upgrade/option.c:245"
  - "postgres/src/bin/pg_verifybackup/pg_verifybackup.c:254"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1237"
  - "postgres/src/bin/pgbench/pgbench.c:7208"
  - "postgres/src/bin/scripts/clusterdb.c:130"
  - "postgres/src/bin/scripts/createdb.c:166"
  - "postgres/src/bin/scripts/createuser.c:208"
  - "postgres/src/bin/scripts/dropdb.c:119"
  - "postgres/src/bin/scripts/dropuser.c:108"
  - "postgres/src/bin/scripts/pg_isready.c:109"
  - "postgres/src/bin/scripts/reindexdb.c:201"
  - "postgres/src/bin/scripts/vacuumdb.c:234"
reproduced: true
---

# `too many command-line arguments (first is "%s")`

## What it means

A command-line tool received more positional (non-option) arguments than it accepts. The placeholder is the first extra argument, to help you spot where the surplus began.

## When it happens

Passing several bare words where the program expects at most one (or none), forgetting to quote an argument that contains spaces (so the shell splits it), or misplacing options after the positional argument. Frequent with `createdb`, `dropdb`, `psql`, `vacuumdb`, and similar.

## How to fix

Check the program's `--help` for how many positional arguments it takes. Quote arguments that contain spaces. Make sure options such as `-h` and `-U` come before or in the right position relative to the positional argument. The named "first is" argument tells you where the extra input started.

## Example

*Reproduced* — this site fired under `reproducers/frontend-run.sh` (scenario `frontend__69_scripts`); see the reproducer for the triggering workload. It emits:

```text
ERROR:  too many command-line arguments (first is "%s")
```

## Related

- [Try "%s --help" for more information](./try-help-for-more-information-c0987f.md)
- [invalid argument for option](./invalid-argument-for-option.md)
