---
message: "could not write file \"%s\": %m"
slug: could-not-write-file
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL, LOG, PANIC]
call_sites:
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:707"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:818"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:2283"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:2514"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:2544"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:2569"
  - "postgres/src/backend/access/transam/twophase.c:1776"
  - "postgres/src/backend/access/transam/twophase.c:1785"
  - "postgres/src/backend/access/transam/xlog.c:9948"
  - "postgres/src/backend/access/transam/xlogfuncs.c:716"
  - "postgres/src/backend/backup/basebackup_server.c:171"
  - "postgres/src/backend/backup/basebackup_server.c:264"
  - "postgres/src/backend/backup/walsummary.c:302"
  - "postgres/src/backend/postmaster/postmaster.c:4153"
  - "postgres/src/backend/postmaster/syslogger.c:1540"
  - "postgres/src/backend/postmaster/syslogger.c:1553"
  - "postgres/src/backend/postmaster/syslogger.c:1566"
  - "postgres/src/backend/utils/cache/relmapper.c:946"
  - "postgres/src/bin/initdb/initdb.c:747"
  - "postgres/src/bin/initdb/initdb.c:1054"
  - "postgres/src/bin/initdb/initdb.c:1073"
  - "postgres/src/bin/pg_combinebackup/backup_label.c:160"
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:764"
  - "postgres/src/bin/pg_combinebackup/write_manifest.c:260"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:1190"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:1202"
  - "postgres/src/bin/pg_rewind/file_ops.c:120"
  - "postgres/src/bin/pg_upgrade/slru_io.c:229"
  - "postgres/src/bin/pg_upgrade/slru_io.c:253"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:651"
  - "postgres/src/common/controldata_utils.c:245"
  - "postgres/src/common/controldata_utils.c:250"
reproduced: false
---

# `could not write file "%s": %m`

## What it means

Writing a file failed (a variant used where the write is a whole-file operation, such as writing the control file or a state file). The path is the first placeholder and `%m` the OS error.

## When it happens

Writing `pg_control`, a two-phase state file, `postmaster.pid`, or similar administrative files, and in client tools when writing output. Usually `No space left on device`, `Permission denied`, or `Read-only file system`.

## How to fix

Read `%m` and address the underlying condition: free disk space, fix ownership, or remount a filesystem that went read-only. Failures writing critical files like `pg_control` are serious — the server may refuse to start until the write can complete, so resolve the storage problem before restarting.

## Example

*Illustrative* — control-file write on a read-only mount.

```text
PANIC:  could not write file "global/pg_control": Read-only file system
```

## Related

- [could not write to file](./could-not-write-to-file-16a7e3.md)
- [could not update checksum of file](./could-not-update-checksum-of-file.md)
