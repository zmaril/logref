---
message: "could not open file \"%s\": %m"
slug: could-not-open-file-420e05
passthrough: false
api: [ereport, pg_fatal, pg_log_error]
level: [DEBUG2, ERROR, FATAL, LOG, PANIC]
level_runtime_chosen: true
call_sites:
  - "postgres/contrib/basic_archive/basic_archive.c:236"
  - "postgres/contrib/basic_archive/basic_archive.c:242"
  - "postgres/contrib/pg_prewarm/autoprewarm.c:750"
  - "postgres/contrib/pg_stash_advice/stashpersist.c:269"
  - "postgres/contrib/pg_stash_advice/stashpersist.c:523"
  - "postgres/src/backend/access/heap/rewriteheap.c:1230"
  - "postgres/src/backend/access/transam/slru.c:1109"
  - "postgres/src/backend/access/transam/timeline.c:110"
  - "postgres/src/backend/access/transam/timeline.c:250"
  - "postgres/src/backend/access/transam/timeline.c:347"
  - "postgres/src/backend/access/transam/twophase.c:1321"
  - "postgres/src/backend/access/transam/xlog.c:3266"
  - "postgres/src/backend/access/transam/xlog.c:3446"
  - "postgres/src/backend/access/transam/xlog.c:3485"
  - "postgres/src/backend/access/transam/xlog.c:3678"
  - "postgres/src/backend/access/transam/xlog.c:4418"
  - "postgres/src/backend/access/transam/xlogrecovery.c:4274"
  - "postgres/src/backend/access/transam/xlogrecovery.c:4375"
  - "postgres/src/backend/access/transam/xlogutils.c:847"
  - "postgres/src/backend/backup/basebackup.c:551"
  - "postgres/src/backend/backup/basebackup.c:1598"
  - "postgres/src/backend/backup/walsummary.c:218"
  - "postgres/src/backend/libpq/hba.c:620"
  - "postgres/src/backend/postmaster/syslogger.c:1529"
  - "postgres/src/backend/replication/logical/origin.c:774"
  - "postgres/src/backend/replication/logical/reorderbuffer.c:4047"
  - "postgres/src/backend/replication/logical/reorderbuffer.c:4601"
  - "postgres/src/backend/replication/logical/reorderbuffer.c:5370"
  - "postgres/src/backend/replication/logical/snapbuild.c:1653"
  - "postgres/src/backend/replication/logical/snapbuild.c:1765"
  - "postgres/src/backend/replication/slot.c:2717"
  - "postgres/src/backend/replication/walsender.c:649"
  - "postgres/src/backend/replication/walsender.c:3333"
  - "postgres/src/backend/storage/file/copydir.c:166"
  - "postgres/src/backend/storage/file/copydir.c:254"
  - "postgres/src/backend/storage/file/fd.c:802"
  - "postgres/src/backend/storage/file/fd.c:3558"
  - "postgres/src/backend/storage/file/fd.c:3788"
  - "postgres/src/backend/storage/file/fd.c:3878"
  - "postgres/src/backend/storage/smgr/md.c:694"
  - "postgres/src/backend/utils/cache/relmapper.c:817"
  - "postgres/src/backend/utils/cache/relmapper.c:934"
  - "postgres/src/backend/utils/error/elog.c:2321"
  - "postgres/src/backend/utils/init/miscinit.c:1534"
  - "postgres/src/backend/utils/init/miscinit.c:1668"
  - "postgres/src/backend/utils/init/miscinit.c:1745"
  - "postgres/src/backend/utils/misc/guc.c:4678"
  - "postgres/src/backend/utils/misc/guc.c:4728"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1834"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1448"
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:386"
  - "postgres/src/bin/pg_checksums/pg_checksums.c:192"
  - "postgres/src/bin/pg_combinebackup/backup_label.c:143"
  - "postgres/src/bin/pg_combinebackup/copy_file.c:69"
  - "postgres/src/bin/pg_combinebackup/copy_file.c:153"
  - "postgres/src/bin/pg_combinebackup/copy_file.c:185"
  - "postgres/src/bin/pg_combinebackup/copy_file.c:189"
  - "postgres/src/bin/pg_combinebackup/copy_file.c:239"
  - "postgres/src/bin/pg_combinebackup/copy_file.c:282"
  - "postgres/src/bin/pg_combinebackup/load_manifest.c:128"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:545"
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:525"
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:640"
  - "postgres/src/bin/pg_combinebackup/write_manifest.c:250"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:1182"
  - "postgres/src/bin/pg_rewind/parsexlog.c:333"
  - "postgres/src/bin/pg_upgrade/check.c:373"
  - "postgres/src/bin/pg_upgrade/check.c:976"
  - "postgres/src/bin/pg_upgrade/check.c:1127"
  - "postgres/src/bin/pg_upgrade/check.c:1191"
  - "postgres/src/bin/pg_upgrade/check.c:1265"
  - "postgres/src/bin/pg_upgrade/check.c:1351"
  - "postgres/src/bin/pg_upgrade/check.c:1439"
  - "postgres/src/bin/pg_upgrade/check.c:1567"
  - "postgres/src/bin/pg_upgrade/check.c:1636"
  - "postgres/src/bin/pg_upgrade/check.c:1721"
  - "postgres/src/bin/pg_upgrade/check.c:1797"
  - "postgres/src/bin/pg_upgrade/check.c:1877"
  - "postgres/src/bin/pg_upgrade/check.c:2227"
  - "postgres/src/bin/pg_upgrade/check.c:2246"
  - "postgres/src/bin/pg_upgrade/check.c:2262"
  - "postgres/src/bin/pg_upgrade/check.c:2306"
  - "postgres/src/bin/pg_upgrade/check.c:2359"
  - "postgres/src/bin/pg_upgrade/check.c:2472"
  - "postgres/src/bin/pg_upgrade/file.c:214"
  - "postgres/src/bin/pg_upgrade/file.c:251"
  - "postgres/src/bin/pg_upgrade/function.c:214"
  - "postgres/src/bin/pg_upgrade/option.c:519"
  - "postgres/src/bin/pg_upgrade/slru_io.c:113"
  - "postgres/src/bin/pg_upgrade/version.c:51"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:193"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:648"
  - "postgres/src/bin/pg_walsummary/pg_walsummary.c:108"
  - "postgres/src/bin/pgbench/pgbench.c:6182"
  - "postgres/src/common/controldata_utils.c:224"
  - "postgres/src/common/controldata_utils.c:231"
  - "postgres/src/common/file_utils.c:69"
  - "postgres/src/common/file_utils.c:370"
  - "postgres/src/common/file_utils.c:428"
  - "postgres/src/common/file_utils.c:502"
  - "postgres/src/fe_utils/recovery_gen.c:141"
reproduced: false
---

# `could not open file "%s": %m`

## What it means

The server or a client tool asked the operating system to open a file and the `open()` call failed. The first placeholder is the path; `%m` is the OS error string (the C `errno`), for example `No such file or directory`, `Permission denied`, or `Too many open files`. The `%m` text is the real diagnosis — this message is a wrapper around whatever the kernel returned.

## When it happens

Reading or writing WAL segments, relation files, temporary files, configuration, SSL material, or backup/archive files. Common causes are a missing or renamed file, wrong ownership or permissions on the data directory, a full or unmounted filesystem, or hitting the process open-file limit.

## How to fix

Read the `%m` text first — it tells you which failure it was. For `Permission denied`, fix ownership so the `postgres` user owns the data directory (`chown -R postgres`). For `No such file or directory`, check the path exists and was not removed out from under the server. For `Too many open files`, raise the OS `nofile` ulimit and reconsider `max_files_per_process`. A full disk shows as `No space left on device`.

## Example

*Illustrative* — a data file whose permissions were changed.

```text
ERROR:  could not open file "base/16384/1259": Permission denied
```

## Related

- [could not read file](./could-not-read-file-54f73a.md)
- [could not write to file](./could-not-write-to-file-16a7e3.md)
