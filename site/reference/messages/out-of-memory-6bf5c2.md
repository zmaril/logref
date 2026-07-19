---
message: "out of memory"
slug: out-of-memory-6bf5c2
passthrough: false
api: [elog, ereport, pg_fatal, pg_log_error]
level: [ERROR, FATAL, LOG, PANIC]
level_runtime_chosen: true
sqlstate:
  - symbol: ERRCODE_FDW_OUT_OF_MEMORY
    code: "HV001"
  - symbol: ERRCODE_OUT_OF_MEMORY
    code: "53200"
  - symbol: ERRCODE_PROGRAM_LIMIT_EXCEEDED
    code: "54000"
call_sites:
  - "postgres/contrib/dblink/dblink.c:1956"
  - "postgres/contrib/dblink/dblink.c:2890"
  - "postgres/contrib/hstore_plpython/hstore_plpython.c:95"
  - "postgres/contrib/ltree_plpython/ltree_plpython.c:48"
  - "postgres/contrib/pg_stash_advice/pg_stash_advice.c:701"
  - "postgres/contrib/pg_stat_statements/pg_stat_statements.c:2347"
  - "postgres/contrib/pg_trgm/trgm_op.c:113"
  - "postgres/contrib/pg_trgm/trgm_op.c:132"
  - "postgres/contrib/pg_walinspect/pg_walinspect.c:124"
  - "postgres/contrib/postgres_fdw/option.c:316"
  - "postgres/src/backend/access/transam/twophase.c:1430"
  - "postgres/src/backend/access/transam/xlogrecovery.c:507"
  - "postgres/src/backend/lib/dshash.c:255"
  - "postgres/src/backend/libpq/auth.c:1390"
  - "postgres/src/backend/libpq/auth.c:1434"
  - "postgres/src/backend/libpq/auth.c:2004"
  - "postgres/src/backend/libpq/be-secure-gssapi.c:537"
  - "postgres/src/backend/libpq/be-secure-gssapi.c:717"
  - "postgres/src/backend/port/posix_sema.c:217"
  - "postgres/src/backend/port/sysv_sema.c:357"
  - "postgres/src/backend/port/win32_sema.c:50"
  - "postgres/src/backend/postmaster/bgworker.c:379"
  - "postgres/src/backend/postmaster/bgworker.c:1043"
  - "postgres/src/backend/postmaster/postmaster.c:3613"
  - "postgres/src/backend/postmaster/walsummarizer.c:933"
  - "postgres/src/backend/replication/logical/logical.c:199"
  - "postgres/src/backend/replication/walsender.c:864"
  - "postgres/src/backend/storage/buffer/localbuf.c:776"
  - "postgres/src/backend/storage/file/fd.c:911"
  - "postgres/src/backend/storage/file/fd.c:1429"
  - "postgres/src/backend/storage/file/fd.c:1590"
  - "postgres/src/backend/storage/file/fd.c:2574"
  - "postgres/src/backend/storage/ipc/procarray.c:1454"
  - "postgres/src/backend/storage/ipc/procarray.c:2154"
  - "postgres/src/backend/storage/ipc/procarray.c:2168"
  - "postgres/src/backend/storage/ipc/procarray.c:2672"
  - "postgres/src/backend/storage/ipc/procarray.c:3393"
  - "postgres/src/backend/utils/activity/pgstat_shmem.c:547"
  - "postgres/src/backend/utils/adt/pg_locale.c:489"
  - "postgres/src/backend/utils/adt/pg_locale.c:563"
  - "postgres/src/backend/utils/adt/pg_locale_icu.c:593"
  - "postgres/src/backend/utils/adt/pg_locale_libc.c:554"
  - "postgres/src/backend/utils/adt/pg_locale_libc.c:653"
  - "postgres/src/backend/utils/adt/pg_locale_libc.c:740"
  - "postgres/src/backend/utils/fmgr/dfmgr.c:232"
  - "postgres/src/backend/utils/hash/dynahash.c:533"
  - "postgres/src/backend/utils/hash/dynahash.c:613"
  - "postgres/src/backend/utils/hash/dynahash.c:1029"
  - "postgres/src/backend/utils/misc/guc.c:644"
  - "postgres/src/backend/utils/misc/guc.c:669"
  - "postgres/src/backend/utils/misc/guc.c:939"
  - "postgres/src/backend/utils/misc/guc.c:4404"
  - "postgres/src/backend/utils/mmgr/aset.c:449"
  - "postgres/src/backend/utils/mmgr/bump.c:183"
  - "postgres/src/backend/utils/mmgr/dsa.c:720"
  - "postgres/src/backend/utils/mmgr/dsa.c:742"
  - "postgres/src/backend/utils/mmgr/dsa.c:823"
  - "postgres/src/backend/utils/mmgr/generation.c:215"
  - "postgres/src/backend/utils/mmgr/mcxt.c:1207"
  - "postgres/src/backend/utils/mmgr/slab.c:368"
  - "postgres/src/bin/initdb/initdb.c:376"
  - "postgres/src/bin/initdb/initdb.c:412"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:1624"
  - "postgres/src/bin/pg_upgrade/server.c:330"
  - "postgres/src/bin/pg_upgrade/task.c:197"
  - "postgres/src/bin/psql/command.c:4080"
  - "postgres/src/bin/psql/command.c:4129"
  - "postgres/src/bin/psql/command.c:4254"
  - "postgres/src/bin/psql/input.c:225"
  - "postgres/src/bin/psql/mainloop.c:80"
  - "postgres/src/bin/psql/mainloop.c:398"
  - "postgres/src/bin/scripts/vacuuming.c:1050"
  - "postgres/src/common/cryptohash_openssl.c:156"
  - "postgres/src/common/hmac_openssl.c:149"
  - "postgres/src/common/psprintf.c:138"
  - "postgres/src/fe_utils/recovery_gen.c:40"
  - "postgres/src/fe_utils/recovery_gen.c:51"
  - "postgres/src/fe_utils/recovery_gen.c:90"
  - "postgres/src/fe_utils/recovery_gen.c:110"
  - "postgres/src/fe_utils/recovery_gen.c:169"
  - "postgres/src/fe_utils/recovery_gen.c:230"
  - "postgres/src/include/libpq/libpq-be-fe.h:77"
  - "postgres/src/port/path.c:844"
  - "postgres/src/port/path.c:881"
  - "postgres/src/port/path.c:898"
reproduced: false
---

# `out of memory`

## What it means

A memory allocation failed: Postgres asked for heap memory (or a related resource) and could not get it. Depending on the site the severity ranges from `ERROR` (the statement is aborted and its memory released) to `FATAL`/`PANIC` (a process or the server cannot continue). The `errdetail` line usually names the allocation size and the memory context.

## When it happens

A query needs more work memory than is available (large sorts, hashes, or `array_agg`/`json_agg` over huge inputs), too many concurrent backends each holding `work_mem`, a memory leak in a long-lived session or extension, or the OS itself being out of memory or hitting a cgroup/ulimit cap. Client tools raise it when they cannot allocate buffers for a large result.

## How to fix

Look at the detail line for the failed size and context — it localizes the culprit. Reduce per-operation memory (`work_mem`, `maintenance_work_mem`) or the concurrency that multiplies it, and check for a query that materializes far more than expected. At the OS level, ensure the host has real headroom, review `overcommit` settings, and check any container memory limit. Persistent growth in one backend suggests a leak worth reporting.

## Example

*Illustrative* — a backend that cannot satisfy an allocation.

```text
ERROR:  out of memory
DETAIL:  Failed on request of size 1073741824 in memory context "ExecutorState".
```

## Related

- [out of shared memory](./out-of-shared-memory.md)
- [array size exceeds the maximum allowed](./array-size-exceeds-the-maximum-allowed-075b47.md)
