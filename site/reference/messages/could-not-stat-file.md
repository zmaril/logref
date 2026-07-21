---
message: "could not stat file \"%s\": %m"
slug: could-not-stat-file
passthrough: false
api: [elog, ereport, pg_fatal, pg_log_error, pg_log_generic]
level: [ERROR, FATAL, LOG]
level_runtime_chosen: true
call_sites:
  - "postgres/contrib/basic_archive/basic_archive.c:182"
  - "postgres/contrib/file_fdw/file_fdw.c:898"
  - "postgres/contrib/pg_stash_advice/stashpersist.c:282"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:2332"
  - "postgres/src/backend/access/transam/twophase.c:1333"
  - "postgres/src/backend/access/transam/xlogarchive.c:110"
  - "postgres/src/backend/access/transam/xlogarchive.c:234"
  - "postgres/src/backend/backup/basebackup.c:361"
  - "postgres/src/backend/backup/basebackup.c:557"
  - "postgres/src/backend/backup/basebackup.c:628"
  - "postgres/src/backend/backup/walsummary.c:245"
  - "postgres/src/backend/catalog/pg_tablespace.c:65"
  - "postgres/src/backend/commands/copyfrom.c:1911"
  - "postgres/src/backend/commands/copyto.c:1214"
  - "postgres/src/backend/commands/extension.c:4012"
  - "postgres/src/backend/commands/tablespace.c:810"
  - "postgres/src/backend/commands/tablespace.c:899"
  - "postgres/src/backend/postmaster/pgarch.c:683"
  - "postgres/src/backend/replication/logical/snapbuild.c:1548"
  - "postgres/src/backend/replication/logical/snapbuild.c:2075"
  - "postgres/src/backend/storage/file/fd.c:1954"
  - "postgres/src/backend/storage/file/fd.c:2042"
  - "postgres/src/backend/storage/file/fd.c:3612"
  - "postgres/src/backend/utils/adt/dbsize.c:103"
  - "postgres/src/backend/utils/adt/dbsize.c:264"
  - "postgres/src/backend/utils/adt/dbsize.c:353"
  - "postgres/src/backend/utils/adt/genfile.c:435"
  - "postgres/src/backend/utils/adt/genfile.c:611"
  - "postgres/src/backend/utils/time/snapmgr.c:1456"
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:319"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:358"
  - "postgres/src/bin/pg_checksums/pg_checksums.c:338"
  - "postgres/src/bin/pg_checksums/pg_checksums.c:407"
  - "postgres/src/bin/pg_combinebackup/backup_label.c:187"
  - "postgres/src/bin/pg_combinebackup/load_manifest.c:133"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:697"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:1153"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:1352"
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:204"
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:422"
  - "postgres/src/bin/pg_rewind/file_ops.c:353"
  - "postgres/src/bin/pg_rewind/file_ops.c:440"
  - "postgres/src/bin/pg_upgrade/relfilenumber.c:279"
  - "postgres/src/bin/pg_verifybackup/pg_verifybackup.c:326"
  - "postgres/src/bin/psql/copy.c:342"
  - "postgres/src/common/file_utils.c:123"
  - "postgres/src/common/file_utils.c:588"
  - "postgres/src/common/file_utils.c:590"
  - "postgres/src/fe_utils/archive.c:86"
  - "postgres/src/fe_utils/version.c:60"
reproduced: true
---

# `could not stat file "%s": %m`

## What it means

The `stat()` system call on a path failed — Postgres could not retrieve a file's metadata (existence, size, type, permissions). The path is the first placeholder and `%m` is the OS error.

## When it happens

Scanning directories, sizing files for backup, checking for the presence of WAL or config files, or validating a tablespace path. `No such file or directory` means the path is gone; `Permission denied` means a directory in the path is not searchable by the server user.

## How to fix

Read `%m`. For `No such file or directory`, confirm the path exists and was not removed or renamed. For `Permission denied`, ensure every directory component is owned/traversable by the `postgres` user. Broken symlinks (for tablespaces) also surface here — check that the link target still exists.

## Example

*Reproduced* — captured from `reproducers/scenarios/22_system_admin_funcs.sql`.

```sql
SELECT pg_stat_file('/nonexistent_xyz');
```

Produces:

```text
ERROR:  could not stat file "/nonexistent_xyz": No such file or directory
```

## Related

- [could not open file](./could-not-open-file-420e05.md)
- [could not access directory](./could-not-access-directory-ab12ea.md)
