---
message: "could not fsync file \"%s\": %m"
slug: could-not-fsync-file-adaa93
passthrough: false
api: [ereport, pg_fatal, pg_log_error]
level: [ERROR, FATAL, PANIC]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/access/heap/rewriteheap.c:926"
  - "postgres/src/backend/access/heap/rewriteheap.c:1136"
  - "postgres/src/backend/access/heap/rewriteheap.c:1241"
  - "postgres/src/backend/access/transam/slru.c:1148"
  - "postgres/src/backend/access/transam/timeline.c:431"
  - "postgres/src/backend/access/transam/timeline.c:505"
  - "postgres/src/backend/access/transam/twophase.c:1797"
  - "postgres/src/backend/access/transam/xlog.c:3366"
  - "postgres/src/backend/access/transam/xlog.c:3564"
  - "postgres/src/backend/access/transam/xlog.c:4391"
  - "postgres/src/backend/access/transam/xlog.c:9341"
  - "postgres/src/backend/backup/basebackup_server.c:205"
  - "postgres/src/backend/replication/logical/snapbuild.c:1691"
  - "postgres/src/backend/replication/slot.c:2615"
  - "postgres/src/backend/replication/slot.c:2727"
  - "postgres/src/backend/storage/file/fd.c:819"
  - "postgres/src/backend/storage/file/fd.c:3899"
  - "postgres/src/backend/storage/smgr/md.c:1477"
  - "postgres/src/backend/storage/smgr/md.c:1537"
  - "postgres/src/backend/storage/sync/sync.c:445"
  - "postgres/src/backend/utils/misc/guc.c:4426"
  - "postgres/src/bin/pg_basebackup/pg_recvlogical.c:214"
  - "postgres/src/common/controldata_utils.c:262"
  - "postgres/src/common/controldata_utils.c:269"
  - "postgres/src/common/file_utils.c:440"
  - "postgres/src/common/file_utils.c:510"
reproduced: false
---

# `could not fsync file "%s": %m`

## What it means

`fsync()` (or the platform equivalent) on a file failed. The path is the first placeholder and `%m` the OS error. `fsync` is how Postgres forces data to durable storage; a failure means the data may not be safely on disk, which is why several sites raise `PANIC`.

## When it happens

At checkpoints (flushing relation files), when durably writing WAL, and when syncing the data directory. Causes include failing storage (`Input/output error`), a full disk surfacing at sync time, or a filesystem/OS that reports a deferred write error only at `fsync`.

## How to fix

Read `%m`. `Input/output error` means the storage failed to persist data — treat it as a durability emergency: on modern Postgres an `fsync` failure triggers a `PANIC` and crash-recovery to avoid assuming lost writes succeeded. Investigate the disk (kernel logs, SMART, RAID), ensure the data actually reached stable storage, and do not disable `fsync` to make the error go away.

## Example

*Illustrative* — a checkpoint sync against failing storage.

```text
PANIC:  could not fsync file "base/16384/1247": Input/output error
```

## Related

- [could not write to file](./could-not-write-to-file-16a7e3.md)
- [could not close file](./could-not-close-file-292e0e.md)
