---
message: "could not remove file \"%s\": %m"
slug: could-not-remove-file-cd3a60
passthrough: false
api: [ereport, pg_fatal, pg_log_warning]
level: [ERROR, FATAL, LOG, PANIC, WARNING]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/access/heap/rewriteheap.c:1215"
  - "postgres/src/backend/access/transam/twophase.c:1736"
  - "postgres/src/backend/access/transam/xlogarchive.c:118"
  - "postgres/src/backend/access/transam/xlogarchive.c:398"
  - "postgres/src/backend/backup/walsummary.c:252"
  - "postgres/src/backend/postmaster/postmaster.c:1082"
  - "postgres/src/backend/postmaster/syslogger.c:1506"
  - "postgres/src/backend/replication/logical/origin.c:630"
  - "postgres/src/backend/replication/logical/reorderbuffer.c:4869"
  - "postgres/src/backend/replication/logical/snapbuild.c:1591"
  - "postgres/src/backend/replication/logical/snapbuild.c:2047"
  - "postgres/src/backend/replication/slot.c:2701"
  - "postgres/src/backend/storage/file/fd.c:877"
  - "postgres/src/backend/storage/file/fd.c:3426"
  - "postgres/src/backend/storage/file/fd.c:3488"
  - "postgres/src/backend/storage/file/reinit.c:259"
  - "postgres/src/backend/storage/ipc/dsm.c:351"
  - "postgres/src/backend/storage/smgr/md.c:409"
  - "postgres/src/backend/storage/smgr/md.c:468"
  - "postgres/src/backend/storage/sync/sync.c:242"
  - "postgres/src/backend/utils/time/snapmgr.c:1609"
  - "postgres/src/bin/pg_archivecleanup/pg_archivecleanup.c:165"
  - "postgres/src/bin/pg_rewind/file_ops.c:206"
  - "postgres/src/common/rmtree.c:97"
reproduced: false
---

# `could not remove file "%s": %m`

## What it means

Deleting a file (`unlink()`) failed. The path is the first placeholder and `%m` the OS error. Postgres removes files when dropping relations, recycling WAL, cleaning temp files, and tearing down shared-memory segments.

## When it happens

Dropping a table/index, cleaning up temporary or backup files, or removing stale segment files. Common `%m`: `Permission denied`, `No such file or directory` (already gone — often benign), or `Device or resource busy` on some filesystems.

## How to fix

Read `%m`. `Permission denied` is an ownership problem on the data directory. `No such file or directory` at cleanup usually means the file was already removed and is often harmless. Persistent failures can leave orphaned files consuming space — investigate the path and, if safe, remove the leftover manually while the server is aware of the state.

## Example

*Illustrative* — cleanup of a temp file the server cannot unlink.

```text
WARNING:  could not remove file "base/pgsql_tmp/pgsql_tmp999.0": Permission denied
```

## Related

- [could not remove directory](./could-not-remove-directory-d7a17a.md)
- [could not rename file to](./could-not-rename-file-to.md)
