---
message: "could not close file \"%s\": %m"
slug: could-not-close-file-292e0e
passthrough: false
api: [elog, ereport, pg_fatal, pg_log_error]
level: [ERROR, FATAL, LOG, PANIC]
level_runtime_chosen: true
call_sites:
  - "postgres/contrib/basic_archive/basic_archive.c:288"
  - "postgres/contrib/basic_archive/basic_archive.c:293"
  - "postgres/contrib/pg_prewarm/autoprewarm.c:806"
  - "postgres/contrib/pg_stash_advice/stashpersist.c:555"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:2389"
  - "postgres/src/backend/access/heap/rewriteheap.c:1142"
  - "postgres/src/backend/access/heap/rewriteheap.c:1247"
  - "postgres/src/backend/access/transam/slru.c:1155"
  - "postgres/src/backend/access/transam/timeline.c:391"
  - "postgres/src/backend/access/transam/timeline.c:437"
  - "postgres/src/backend/access/transam/timeline.c:511"
  - "postgres/src/backend/access/transam/twophase.c:1377"
  - "postgres/src/backend/access/transam/twophase.c:1803"
  - "postgres/src/backend/access/transam/xlog.c:3376"
  - "postgres/src/backend/access/transam/xlog.c:3570"
  - "postgres/src/backend/access/transam/xlog.c:3575"
  - "postgres/src/backend/access/transam/xlog.c:3711"
  - "postgres/src/backend/access/transam/xlog.c:4398"
  - "postgres/src/backend/access/transam/xlog.c:5687"
  - "postgres/src/backend/commands/copyfrom.c:1951"
  - "postgres/src/backend/commands/copyto.c:756"
  - "postgres/src/backend/libpq/be-fsstubs.c:473"
  - "postgres/src/backend/libpq/be-fsstubs.c:543"
  - "postgres/src/backend/replication/logical/origin.c:722"
  - "postgres/src/backend/replication/logical/origin.c:860"
  - "postgres/src/backend/replication/logical/reorderbuffer.c:5442"
  - "postgres/src/backend/replication/logical/snapbuild.c:1698"
  - "postgres/src/backend/replication/logical/snapbuild.c:1824"
  - "postgres/src/backend/replication/slot.c:2631"
  - "postgres/src/backend/replication/slot.c:2797"
  - "postgres/src/backend/replication/walsender.c:697"
  - "postgres/src/backend/storage/file/copydir.c:223"
  - "postgres/src/backend/storage/file/copydir.c:228"
  - "postgres/src/backend/storage/file/copydir.c:283"
  - "postgres/src/backend/storage/file/copydir.c:288"
  - "postgres/src/backend/storage/file/fd.c:827"
  - "postgres/src/backend/storage/file/fd.c:1291"
  - "postgres/src/backend/storage/file/fd.c:1988"
  - "postgres/src/backend/storage/file/fd.c:3801"
  - "postgres/src/backend/storage/file/fd.c:3907"
  - "postgres/src/backend/utils/cache/relmapper.c:840"
  - "postgres/src/backend/utils/cache/relmapper.c:955"
  - "postgres/src/bin/initdb/initdb.c:751"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:655"
  - "postgres/src/bin/pg_combinebackup/backup_label.c:174"
  - "postgres/src/bin/pg_combinebackup/copy_file.c:71"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:560"
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:369"
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:745"
  - "postgres/src/bin/pg_combinebackup/write_manifest.c:187"
  - "postgres/src/bin/pg_rewind/local_source.c:119"
  - "postgres/src/bin/pg_rewind/local_source.c:170"
  - "postgres/src/bin/pg_waldump/archive_waldump.c:291"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:654"
  - "postgres/src/common/controldata_utils.c:127"
  - "postgres/src/common/controldata_utils.c:133"
  - "postgres/src/common/controldata_utils.c:276"
  - "postgres/src/common/controldata_utils.c:281"
  - "postgres/src/fe_utils/astreamer_file.c:141"
  - "postgres/src/fe_utils/astreamer_file.c:282"
reproduced: false
---

# `could not close file "%s": %m`

## What it means

The `close()` system call on a file failed. The path is the first placeholder and `%m` is the OS error. A failing `close()` is often the first point at which deferred write errors surface — on many systems buffered data is only flushed at close, so this can mean the earlier write did not actually reach disk.

## When it happens

Closing WAL segments, relation files, temp files, or backup output. Typical `%m` values are `No space left on device` (the flush at close failed), `Input/output error` (failing storage), or `Stale file handle` (a network filesystem problem).

## How to fix

Read `%m`. `No space left on device` means the filesystem filled up — free space and check the write actually completed. `Input/output error` points at failing hardware; inspect kernel logs and SMART data. Because a bad `close()` can mean lost data, treat it as serious for WAL and data files, and verify integrity afterward.

## Example

*Illustrative* — a filesystem that filled during a write.

```text
ERROR:  could not close file "pg_wal/000000010000000000000003": No space left on device
```

## Related

- [could not open file](./could-not-open-file-420e05.md)
- [could not fsync file](./could-not-fsync-file-adaa93.md)
