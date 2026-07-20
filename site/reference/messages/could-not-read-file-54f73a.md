---
message: "could not read file \"%s\": %m"
slug: could-not-read-file-54f73a
passthrough: false
api: [elog, ereport, pg_fatal, pg_log_error]
level: [ERROR, FATAL, LOG, PANIC]
level_runtime_chosen: true
call_sites:
  - "postgres/contrib/basic_archive/basic_archive.c:256"
  - "postgres/contrib/basic_archive/basic_archive.c:269"
  - "postgres/contrib/pg_prewarm/autoprewarm.c:332"
  - "postgres/contrib/pg_stash_advice/stashpersist.c:314"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:695"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:2322"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:2377"
  - "postgres/src/backend/access/transam/timeline.c:142"
  - "postgres/src/backend/access/transam/timeline.c:361"
  - "postgres/src/backend/access/transam/twophase.c:1365"
  - "postgres/src/backend/access/transam/xlog.c:3530"
  - "postgres/src/backend/access/transam/xlog.c:4428"
  - "postgres/src/backend/access/transam/xlogrecovery.c:1195"
  - "postgres/src/backend/access/transam/xlogrecovery.c:1293"
  - "postgres/src/backend/access/transam/xlogrecovery.c:1330"
  - "postgres/src/backend/access/transam/xlogrecovery.c:1397"
  - "postgres/src/backend/backup/basebackup.c:2143"
  - "postgres/src/backend/backup/walsummary.c:281"
  - "postgres/src/backend/commands/extension.c:4033"
  - "postgres/src/backend/libpq/hba.c:763"
  - "postgres/src/backend/replication/logical/origin.c:784"
  - "postgres/src/backend/replication/logical/origin.c:812"
  - "postgres/src/backend/replication/logical/reorderbuffer.c:5390"
  - "postgres/src/backend/replication/logical/snapbuild.c:1953"
  - "postgres/src/backend/replication/slot.c:2745"
  - "postgres/src/backend/replication/slot.c:2786"
  - "postgres/src/backend/replication/walsender.c:682"
  - "postgres/src/backend/storage/file/buffile.c:469"
  - "postgres/src/backend/storage/file/copydir.c:200"
  - "postgres/src/backend/utils/adt/genfile.c:195"
  - "postgres/src/backend/utils/adt/misc.c:999"
  - "postgres/src/backend/utils/cache/relmapper.c:828"
  - "postgres/src/backend/utils/time/snapmgr.c:1461"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1861"
  - "postgres/src/bin/pg_basebackup/pg_receivewal.c:402"
  - "postgres/src/bin/pg_combinebackup/copy_file.c:164"
  - "postgres/src/bin/pg_combinebackup/load_manifest.c:161"
  - "postgres/src/bin/pg_combinebackup/load_manifest.c:199"
  - "postgres/src/bin/pg_combinebackup/pg_combinebackup.c:1369"
  - "postgres/src/bin/pg_combinebackup/reconstruct.c:542"
  - "postgres/src/bin/pg_resetwal/pg_resetwal.c:625"
  - "postgres/src/bin/pg_rewind/file_ops.c:364"
  - "postgres/src/bin/pg_rewind/local_source.c:102"
  - "postgres/src/bin/pg_rewind/local_source.c:161"
  - "postgres/src/bin/pg_rewind/parsexlog.c:371"
  - "postgres/src/bin/pg_upgrade/slru_io.c:131"
  - "postgres/src/bin/pg_verifybackup/pg_verifybackup.c:455"
  - "postgres/src/bin/pg_verifybackup/pg_verifybackup.c:493"
  - "postgres/src/bin/pg_waldump/archive_waldump.c:548"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:259"
  - "postgres/src/bin/pg_walsummary/pg_walsummary.c:251"
  - "postgres/src/bin/pgbench/pgbench.c:6187"
  - "postgres/src/common/controldata_utils.c:107"
  - "postgres/src/common/controldata_utils.c:111"
reproduced: false
---

# `could not read file "%s": %m`

## What it means

A `read()` from a file returned an error. The path is the first placeholder and `%m` is the OS error. This is distinct from reading fewer bytes than expected — here the read call itself failed.

## When it happens

Reading WAL, relation files, temp files, configuration, or backup input. Common `%m` values are `Input/output error` (failing storage), `Permission denied`, or `Bad file descriptor`. On network filesystems, transient errors like `Stale file handle` appear here.

## How to fix

Read `%m` for the specific cause. `Input/output error` indicates failing storage — check kernel logs, SMART data, and RAID health, and consider it a data-integrity emergency for WAL/data files. `Permission denied` is an ownership problem on the data directory. Verify the affected file and, if hardware is suspect, fail over and restore.

## Example

*Illustrative* — a read against failing storage.

```text
ERROR:  could not read file "base/16384/2836": Input/output error
```

## Related

- [could not read file: read %d of %zu](./could-not-read-file-read-of-345e80.md)
- [could not open file](./could-not-open-file-420e05.md)
