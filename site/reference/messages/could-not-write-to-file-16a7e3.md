---
message: "could not write to file \"%s\": %m"
slug: could-not-write-to-file-16a7e3
passthrough: false
api: [ereport, pg_fatal]
level: [ERROR, FATAL, LOG, PANIC]
level_runtime_chosen: true
call_sites:
  - "postgres/contrib/pg_prewarm/autoprewarm.c:763"
  - "postgres/contrib/pg_prewarm/autoprewarm.c:786"
  - "postgres/contrib/pg_stash_advice/stashpersist.c:774"
  - "postgres/src/backend/access/heap/rewriteheap.c:1123"
  - "postgres/src/backend/access/transam/timeline.c:383"
  - "postgres/src/backend/access/transam/timeline.c:423"
  - "postgres/src/backend/access/transam/timeline.c:497"
  - "postgres/src/backend/access/transam/xlog.c:3344"
  - "postgres/src/backend/access/transam/xlog.c:3555"
  - "postgres/src/backend/access/transam/xlog.c:4382"
  - "postgres/src/backend/postmaster/launch_backend.c:341"
  - "postgres/src/backend/postmaster/launch_backend.c:353"
  - "postgres/src/backend/replication/logical/origin.c:654"
  - "postgres/src/backend/replication/logical/origin.c:696"
  - "postgres/src/backend/replication/logical/origin.c:715"
  - "postgres/src/backend/replication/logical/snapbuild.c:1667"
  - "postgres/src/backend/replication/slot.c:2595"
  - "postgres/src/backend/storage/file/buffile.c:544"
  - "postgres/src/backend/storage/file/copydir.c:212"
  - "postgres/src/backend/utils/init/miscinit.c:1609"
  - "postgres/src/backend/utils/init/miscinit.c:1620"
  - "postgres/src/backend/utils/init/miscinit.c:1628"
  - "postgres/src/backend/utils/misc/guc.c:4387"
  - "postgres/src/backend/utils/misc/guc.c:4418"
  - "postgres/src/backend/utils/misc/guc.c:5577"
  - "postgres/src/backend/utils/misc/guc.c:5595"
  - "postgres/src/backend/utils/time/snapmgr.c:1257"
  - "postgres/src/backend/utils/time/snapmgr.c:1264"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1421"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1715"
  - "postgres/src/bin/pg_basebackup/pg_createsubscriber.c:1451"
  - "postgres/src/bin/pg_combinebackup/copy_file.c:200"
  - "postgres/src/fe_utils/astreamer_file.c:124"
  - "postgres/src/fe_utils/astreamer_file.c:273"
  - "postgres/src/fe_utils/recovery_gen.c:144"
reproduced: true
---

# `could not write to file "%s": %m`

## What it means

A `write()` to a file failed or wrote fewer bytes than requested. The path is the first placeholder and `%m` is the OS error. For durability, Postgres treats a short or failed write as an error rather than continuing.

## When it happens

Writing WAL, flushing dirty buffers to relation files, spilling sorts/hashes to temp files, or writing backup output. The dominant cause is `No space left on device`; `Input/output error` (failing storage) and `Disk quota exceeded` also appear.

## How to fix

Read `%m`. `No space left on device` means free up space (or move `pg_wal`/temp files) — a full WAL disk can halt the server. `Disk quota exceeded` is a per-user quota, not raw disk. `Input/output error` indicates failing hardware and possible data loss; treat it as an emergency and verify integrity. Monitor free space so this does not recur.

## Example

*Reproduced* — captured from `reproducers/env-run.sh` (scenario `tier4__disk_full`).

```sql
INSERT INTO fill SELECT repeat('x',1000) FROM generate_series(1,10000000);
```

Produces:

```text
ERROR:  could not write to file "base/pgsql_tmp/pgsql_tmp12555.0": No space left on device
```

## Related

- [could not write file](./could-not-write-file.md)
- [could not fsync file](./could-not-fsync-file-adaa93.md)
