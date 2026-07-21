---
message: "could not create directory \"%s\": %m"
slug: could-not-create-directory
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL]
call_sites:
  - "postgres/src/backend/backup/basebackup_server.c:100"
  - "postgres/src/backend/commands/tablespace.c:157"
  - "postgres/src/backend/commands/tablespace.c:173"
  - "postgres/src/backend/commands/tablespace.c:599"
  - "postgres/src/backend/commands/tablespace.c:644"
  - "postgres/src/backend/replication/slot.c:2486"
  - "postgres/src/backend/storage/file/copydir.c:57"
  - "postgres/src/bin/initdb/initdb.c:2934"
  - "postgres/src/bin/initdb/initdb.c:3005"
  - "postgres/src/bin/initdb/initdb.c:3053"
  - "postgres/src/bin/initdb/initdb.c:3110"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:700"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:714"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:759"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1002"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1006"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:416"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:751"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:949"
  - "postgres/src/bin/pg_dump/dumputils.c:956"
  - "postgres/src/bin/pg_rewind/file_ops.c:251"
  - "postgres/src/bin/pg_upgrade/pg_upgrade.c:325"
  - "postgres/src/bin/pg_upgrade/pg_upgrade.c:327"
  - "postgres/src/bin/pg_upgrade/pg_upgrade.c:329"
  - "postgres/src/bin/pg_upgrade/pg_upgrade.c:331"
  - "postgres/src/bin/pg_upgrade/relfilenumber.c:285"
  - "postgres/src/bin/pg_upgrade/relfilenumber.c:289"
  - "postgres/src/bin/pg_waldump/archive_waldump.c:595"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:131"
  - "postgres/src/fe_utils/astreamer_file.c:338"
reproduced: false
---

# `could not create directory "%s": %m`

## What it means

Creating a directory failed (`mkdir()`). The path is the first placeholder and `%m` the OS error. Postgres creates directories for tablespaces, subdirectories under the data directory, and backup output.

## When it happens

`CREATE TABLESPACE`, `initdb`, `pg_basebackup` writing to a destination, or creating internal subdirectories. Typical `%m`: `Permission denied` (the parent is not writable by the server user), `File exists`, `No space left on device`, or `Read-only file system`.

## How to fix

Read `%m`. For `Permission denied`, ensure the parent directory is owned by and writable by the `postgres` user. For `File exists`, the target path is already present — choose another or remove the stale directory. For tablespaces, the location must be an empty directory owned by the server user.

## Example

*Illustrative* — a tablespace location the server user cannot write.

```sql
CREATE TABLESPACE fast LOCATION '/mnt/fast/pg';
```

Produces:

```text
ERROR:  could not create directory "/mnt/fast/pg": Permission denied
```

## Related

- [could not create file](./could-not-create-file.md)
- [could not open directory](./could-not-open-directory.md)
