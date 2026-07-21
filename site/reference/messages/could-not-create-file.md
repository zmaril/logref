---
message: "could not create file \"%s\": %m"
slug: could-not-create-file
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL, LOG, PANIC]
level_runtime_chosen: true
call_sites:
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:2766"
  - "postgres/src/backend/access/heap/rewriteheap.c:978"
  - "postgres/src/backend/access/heap/rewriteheap.c:1095"
  - "postgres/src/backend/access/transam/timeline.c:328"
  - "postgres/src/backend/access/transam/timeline.c:480"
  - "postgres/src/backend/access/transam/xlog.c:3291"
  - "postgres/src/backend/access/transam/xlog.c:3499"
  - "postgres/src/backend/access/transam/xlog.c:4370"
  - "postgres/src/backend/access/transam/xlog.c:9937"
  - "postgres/src/backend/access/transam/xlogfuncs.c:710"
  - "postgres/src/backend/backup/basebackup_server.c:147"
  - "postgres/src/backend/backup/basebackup_server.c:240"
  - "postgres/src/backend/postmaster/launch_backend.c:330"
  - "postgres/src/backend/postmaster/postmaster.c:4140"
  - "postgres/src/backend/postmaster/walsummarizer.c:1216"
  - "postgres/src/backend/replication/logical/origin.c:642"
  - "postgres/src/backend/replication/slot.c:2559"
  - "postgres/src/backend/storage/file/copydir.c:172"
  - "postgres/src/backend/storage/file/copydir.c:260"
  - "postgres/src/backend/storage/smgr/md.c:260"
  - "postgres/src/backend/utils/time/snapmgr.c:1252"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1485"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1694"
  - "postgres/src/bin/pg_combinebackup/copy_file.c:243"
  - "postgres/src/bin/pg_combinebackup/copy_file.c:286"
  - "postgres/src/bin/pg_upgrade/file.c:219"
  - "postgres/src/bin/pg_upgrade/file.c:256"
  - "postgres/src/bin/pg_upgrade/slru_io.c:221"
  - "postgres/src/bin/pg_waldump/archive_waldump.c:622"
  - "postgres/src/fe_utils/astreamer_file.c:96"
  - "postgres/src/fe_utils/astreamer_file.c:378"
  - "postgres/src/fe_utils/recovery_gen.c:153"
reproduced: false
---

# `could not create file "%s": %m`

## What it means

Creating a new file failed — the `open()` with `O_CREAT` did not succeed. The path is the first placeholder and `%m` is the OS error. The server needs to create files constantly (WAL segments, new relation forks, temp files), so this blocks real work.

## When it happens

Extending a relation, switching WAL segments, spilling to a temp file, or writing backup output. Common `%m` values: `No space left on device`, `Permission denied`, `Too many open files`, or `Read-only file system`.

## How to fix

Read `%m`. `No space left on device` — free space. `Permission denied` — fix data-directory ownership. `Read-only file system` — the mount went read-only (often after an I/O error), so check the kernel log and remount cleanly. `Too many open files` — raise the `nofile` ulimit. Until the underlying condition clears, writes will keep failing.

## Example

*Illustrative* — WAL segment creation on a full disk.

```text
ERROR:  could not create file "pg_wal/000000010000000000000009": No space left on device
```

## Related

- [could not open file](./could-not-open-file-420e05.md)
- [could not create directory](./could-not-create-directory.md)
