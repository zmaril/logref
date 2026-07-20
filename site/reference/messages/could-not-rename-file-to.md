---
message: "could not rename file \"%s\" to \"%s\": %m"
slug: could-not-rename-file-to
passthrough: false
api: [ereport, pg_fatal, pg_log_error]
level: [ERROR, FATAL, LOG, WARNING]
level_runtime_chosen: true
call_sites:
  - "postgres/src/backend/access/transam/xlogarchive.c:388"
  - "postgres/src/backend/postmaster/pgarch.c:837"
  - "postgres/src/backend/postmaster/syslogger.c:1577"
  - "postgres/src/backend/replication/logical/snapbuild.c:1710"
  - "postgres/src/backend/replication/slot.c:1104"
  - "postgres/src/backend/replication/slot.c:2498"
  - "postgres/src/backend/replication/slot.c:2647"
  - "postgres/src/backend/storage/file/fd.c:837"
  - "postgres/src/backend/utils/time/snapmgr.c:1273"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2332"
  - "postgres/src/bin/pg_upgrade/controldata.c:692"
  - "postgres/src/bin/pg_upgrade/relfilenumber.c:385"
  - "postgres/src/bin/pg_upgrade/relfilenumber.c:412"
  - "postgres/src/common/file_utils.c:520"
reproduced: false
---

# `could not rename file "%s" to "%s": %m`

## What it means

A `rename()` of one path to another failed. The two placeholders are the source and destination; `%m` is the OS error. Postgres uses atomic rename to publish files safely (WAL, control file, temp-to-final), so a failed rename can leave an operation incomplete.

## When it happens

Finalizing a written file (config reload, control-file update, WAL recycling, backup output). Common `%m`: `No space left on device`, `Permission denied`, or a cross-device rename (`Invalid cross-device link`) when source and destination are on different filesystems.

## How to fix

Read `%m`. `Permission denied` is an ownership problem on the directory. `No space left on device` needs freed space. `Invalid cross-device link` means the two paths are on different mounts — the destination directory (or a tablespace/temp location) must be on the same filesystem as the source. Fix the underlying condition; a failed rename may need the operation retried.

## Example

*Illustrative* — a cross-filesystem rename.

```text
ERROR:  could not rename file "pg_wal/x.tmp" to "pg_wal/x": Invalid cross-device link
```

## Related

- [could not remove file](./could-not-remove-file-cd3a60.md)
- [could not create file](./could-not-create-file.md)
