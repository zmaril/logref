---
message: "could not open directory \"%s\": %m"
slug: could-not-open-directory
passthrough: false
api: [ereport, pg_fatal, pg_log_error, pg_log_warning]
level: [ERROR, FATAL, LOG, WARNING]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/commands/tablespace.c:734"
  - "postgres/src/backend/commands/tablespace.c:744"
  - "postgres/src/backend/postmaster/postmaster.c:1509"
  - "postgres/src/backend/storage/file/fd.c:2979"
  - "postgres/src/backend/storage/file/reinit.c:124"
  - "postgres/src/backend/utils/adt/misc.c:270"
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:242"
  - "postgres/src/bin/pg_checksums/pg_checksums.c:310"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:955"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:1225"
  - "postgres/src/bin/pg_dump/dumputils.c:951"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:971"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:1024"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:1059"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:1099"
  - "postgres/src/bin/pg_rewind/file_ops.c:411"
  - "postgres/src/bin/pg_upgrade/relfilenumber.c:367"
  - "postgres/src/bin/pg_upgrade/relfilenumber.c:394"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1252"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:1286"
  - "postgres/src/common/file_utils.c:156"
  - "postgres/src/common/file_utils.c:304"
  - "postgres/src/common/pgfnames.c:48"
  - "postgres/src/common/rmtree.c:63"
  - "postgres/src/timezone/pgtz.c:387"
  - "postgres/src/timezone/pgtz.c:440"
reproduced: false
---

# `could not open directory "%s": %m`

## What it means

Opening a directory to list its contents (`opendir()`) failed. The path is the first placeholder and `%m` the OS error. Postgres scans directories to find WAL segments, relation files, tablespaces, and more.

## When it happens

Reading `pg_wal`, a tablespace directory, the data directory, or a backup source. Common `%m`: `Permission denied` (the directory is not searchable by the server user), `No such file or directory` (it was removed), or `Too many open files`.

## How to fix

Read `%m`. For `Permission denied`, ensure the directory and its parents are owned and traversable by the `postgres` user. For `No such file or directory`, confirm the path exists — a removed tablespace directory or a broken symlink shows up here. Fix the underlying filesystem condition rather than the message.

## Example

*Illustrative* — a tablespace directory the server user cannot read.

```text
ERROR:  could not open directory "/mnt/data/pg_tblspc": Permission denied
```

## Related

- [could not read directory](./could-not-read-directory.md)
- [could not access directory](./could-not-access-directory-ab12ea.md)
