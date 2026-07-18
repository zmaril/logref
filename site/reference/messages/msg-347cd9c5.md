---
message: "%s"
slug: msg-347cd9c5
passthrough: true
api: [ereport, pg_log_error, elog, pg_fatal, pg_log_info, pg_log_warning_detail, pg_log_debug]
level: [ERROR, LOG, COMMERROR, DEBUG3, WARNING, NOTICE, FATAL, INFO, DEBUG]
level_runtime_chosen: true
call_sites:
  - "postgres/contrib/dblink/dblink.c:2845"
  - "postgres/contrib/oid2name/oid2name.c:348"
  - "postgres/contrib/pg_walinspect/pg_walinspect.c:399"
  - "postgres/contrib/pgcrypto/px.c:105"
  - "postgres/contrib/postgres_fdw/connection.c:1153"
  - "postgres/contrib/vacuumlo/vacuumlo.c:127"
  - "postgres/contrib/vacuumlo/vacuumlo.c:231"
  - "postgres/src/backend/access/common/attmap.c:115"
  - "postgres/src/backend/access/common/attmap.c:144"
  - "postgres/src/backend/access/heap/vacuumlazy.c:1225"
  - "postgres/src/backend/access/transam/xlog.c:1100"
  - "postgres/src/backend/access/transam/xlogrecovery.c:1728"
  - "postgres/src/backend/access/transam/xlogrecovery.c:2516"
  - "postgres/src/backend/access/transam/xlogrecovery.c:3165"
  - "postgres/src/backend/access/transam/xlogrecovery.c:3468"
  - "postgres/src/backend/access/transam/xlogutils.c:404"
  - "postgres/src/backend/backup/basebackup_incremental.c:1040"
  - "postgres/src/backend/backup/walsummary.c:338"
  - "postgres/src/backend/catalog/dependency.c:1242"
  - "postgres/src/backend/commands/analyze.c:854"
  - "postgres/src/backend/libpq/auth.c:1227"
  - "postgres/src/backend/libpq/auth.c:1231"
  - "postgres/src/backend/libpq/be-gssapi-common.c:91"
  - "postgres/src/backend/parser/parse_agg.c:613"
  - "postgres/src/backend/parser/parse_agg.c:1058"
  - "postgres/src/backend/parser/parse_expr.c:604"
  - "postgres/src/backend/parser/parse_expr.c:1905"
  - "postgres/src/backend/parser/parse_func.c:2806"
  - "postgres/src/backend/postmaster/postmaster.c:891"
  - "postgres/src/backend/replication/slot.c:281"
  - "postgres/src/backend/storage/file/fd.c:1249"
  - "postgres/src/backend/tcop/postgres.c:5342"
  - "postgres/src/backend/utils/adt/xml.c:2082"
  - "postgres/src/backend/utils/adt/xml.c:2296"
  - "postgres/src/backend/utils/adt/xml.c:2301"
  - "postgres/src/backend/utils/init/postinit.c:324"
  - "postgres/src/backend/utils/init/postinit.c:1556"
  - "postgres/src/backend/utils/misc/guc.c:6694"
  - "postgres/src/backend/utils/misc/guc.c:6728"
  - "postgres/src/backend/utils/misc/guc.c:6762"
  - "postgres/src/backend/utils/misc/guc.c:6805"
  - "postgres/src/backend/utils/misc/guc.c:6846"
  - "postgres/src/bin/pg_basebackup/pg_basebackup.c:2236"
  - "postgres/src/bin/pg_basebackup/streamutil.c:89"
  - "postgres/src/bin/pg_basebackup/streamutil.c:204"
  - "postgres/src/bin/pg_dump/connectdb.c:83"
  - "postgres/src/bin/pg_dump/connectdb.c:174"
  - "postgres/src/bin/pg_dump/pg_backup_db.c:203"
  - "postgres/src/bin/pg_dump/pg_dump.c:943"
  - "postgres/src/bin/pg_dump/pg_dump_sort.c:1479"
  - "postgres/src/bin/pg_dump/pg_dump_sort.c:1499"
  - "postgres/src/bin/pg_rewind/pg_rewind.c:316"
  - "postgres/src/bin/pg_upgrade/util.c:337"
  - "postgres/src/bin/pg_waldump/pg_waldump.c:631"
  - "postgres/src/bin/pgbench/pgbench.c:1518"
  - "postgres/src/bin/pgbench/pgbench.c:1581"
  - "postgres/src/bin/pgbench/pgbench.c:3105"
  - "postgres/src/bin/pgbench/pgbench.c:3659"
  - "postgres/src/bin/pgbench/pgbench.c:4387"
  - "postgres/src/bin/pgbench/pgbench.c:5597"
  - "postgres/src/bin/psql/command.c:1657"
  - "postgres/src/bin/psql/command.c:2597"
  - "postgres/src/bin/psql/command.c:4076"
  - "postgres/src/bin/psql/command.c:4274"
  - "postgres/src/bin/psql/command.c:6552"
  - "postgres/src/bin/psql/common.c:233"
  - "postgres/src/bin/psql/common.c:282"
  - "postgres/src/bin/psql/common.c:457"
  - "postgres/src/bin/psql/common.c:1180"
  - "postgres/src/bin/psql/common.c:1198"
  - "postgres/src/bin/psql/common.c:1266"
  - "postgres/src/bin/psql/common.c:1378"
  - "postgres/src/bin/psql/common.c:1416"
  - "postgres/src/bin/psql/common.c:1720"
  - "postgres/src/bin/psql/common.c:1800"
  - "postgres/src/bin/psql/copy.c:486"
  - "postgres/src/bin/psql/copy.c:731"
  - "postgres/src/bin/psql/large_obj.c:157"
  - "postgres/src/bin/psql/large_obj.c:192"
  - "postgres/src/bin/psql/large_obj.c:254"
  - "postgres/src/bin/psql/startup.c:310"
  - "postgres/src/bin/scripts/pg_isready.c:146"
  - "postgres/src/common/scram-common.c:286"
  - "postgres/src/common/scram-common.c:302"
  - "postgres/src/common/scram-common.c:319"
  - "postgres/src/fe_utils/connect_utils.c:116"
  - "postgres/src/fe_utils/recovery_gen.c:215"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3942"
  - "postgres/src/pl/plpgsql/src/pl_exec.c:3998"
  - "postgres/src/pl/plpython/plpy_elog.c:123"
  - "postgres/src/pl/plpython/plpy_plpymodule.c:497"
  - "postgres/src/pl/tcl/pltcl.c:1404"
  - "postgres/src/pl/tcl/pltcl.c:1898"
reproduced: false
---

# `%s`

**Severity:** ERROR / LOG / COMMERROR / DEBUG3 / WARNING / NOTICE / FATAL / INFO / DEBUG (some call sites choose the severity at runtime)

## What it means

This is not one message but a passthrough: the entire text is a single `%s` placeholder, so the real content is assembled at runtime and inserted whole. Postgres uses this shape in dozens of places to relay a string it built elsewhere — a formatted sub-error, a message from a library, a generated report — where the wording is not known statically. The severity and SQLSTATE therefore vary by call site rather than being fixed by the text.

## When it happens

Emitted from many unrelated call sites across the tree, at every severity from `DEBUG` to `FATAL`. Because the literal is just `%s`, the static catalog cannot tell you what any given occurrence will actually say — the words come from the argument at that specific site.

## How to fix

There is nothing to act on from the format string alone. A passthrough line must be diagnosed by its rendered content and its source location: with `log_error_verbosity = verbose`, the `file_name`/`file_line_num` in `jsonlog` pin down which of these call sites emitted it, and the reference page for that specific site (once enriched) carries the real guidance. This page exists mainly to document the passthrough pattern itself.

## Source

This message text is emitted from 93 call sites:

- [`postgres/contrib/dblink/dblink.c:2845`](https://github.com/postgres/postgres/blob/master/contrib/dblink/dblink.c#L2845) — severity chosen at runtime
- [`postgres/contrib/oid2name/oid2name.c:348`](https://github.com/postgres/postgres/blob/master/contrib/oid2name/oid2name.c#L348) — ERROR
- [`postgres/contrib/pg_walinspect/pg_walinspect.c:399`](https://github.com/postgres/postgres/blob/master/contrib/pg_walinspect/pg_walinspect.c#L399) — ERROR
- [`postgres/contrib/pgcrypto/px.c:105`](https://github.com/postgres/postgres/blob/master/contrib/pgcrypto/px.c#L105) — ERROR
- [`postgres/contrib/postgres_fdw/connection.c:1153`](https://github.com/postgres/postgres/blob/master/contrib/postgres_fdw/connection.c#L1153) — severity chosen at runtime
- [`postgres/contrib/vacuumlo/vacuumlo.c:127`](https://github.com/postgres/postgres/blob/master/contrib/vacuumlo/vacuumlo.c#L127) — ERROR
- [`postgres/contrib/vacuumlo/vacuumlo.c:231`](https://github.com/postgres/postgres/blob/master/contrib/vacuumlo/vacuumlo.c#L231) — ERROR
- [`postgres/src/backend/access/common/attmap.c:115`](https://github.com/postgres/postgres/blob/master/src/backend/access/common/attmap.c#L115) — ERROR
- [`postgres/src/backend/access/common/attmap.c:144`](https://github.com/postgres/postgres/blob/master/src/backend/access/common/attmap.c#L144) — ERROR
- [`postgres/src/backend/access/heap/vacuumlazy.c:1225`](https://github.com/postgres/postgres/blob/master/src/backend/access/heap/vacuumlazy.c#L1225) — severity chosen at runtime
- [`postgres/src/backend/access/transam/xlog.c:1100`](https://github.com/postgres/postgres/blob/master/src/backend/access/transam/xlog.c#L1100) — LOG
- [`postgres/src/backend/access/transam/xlogrecovery.c:1728`](https://github.com/postgres/postgres/blob/master/src/backend/access/transam/xlogrecovery.c#L1728) — LOG
- [`postgres/src/backend/access/transam/xlogrecovery.c:2516`](https://github.com/postgres/postgres/blob/master/src/backend/access/transam/xlogrecovery.c#L2516) — ERROR
- [`postgres/src/backend/access/transam/xlogrecovery.c:3165`](https://github.com/postgres/postgres/blob/master/src/backend/access/transam/xlogrecovery.c#L3165) — severity chosen at runtime
- [`postgres/src/backend/access/transam/xlogrecovery.c:3468`](https://github.com/postgres/postgres/blob/master/src/backend/access/transam/xlogrecovery.c#L3468) — severity chosen at runtime
- [`postgres/src/backend/access/transam/xlogutils.c:404`](https://github.com/postgres/postgres/blob/master/src/backend/access/transam/xlogutils.c#L404) — ERROR
- [`postgres/src/backend/backup/basebackup_incremental.c:1040`](https://github.com/postgres/postgres/blob/master/src/backend/backup/basebackup_incremental.c#L1040) — ERROR
- [`postgres/src/backend/backup/walsummary.c:338`](https://github.com/postgres/postgres/blob/master/src/backend/backup/walsummary.c#L338) — ERROR
- [`postgres/src/backend/catalog/dependency.c:1242`](https://github.com/postgres/postgres/blob/master/src/backend/catalog/dependency.c#L1242) — severity chosen at runtime
- [`postgres/src/backend/commands/analyze.c:854`](https://github.com/postgres/postgres/blob/master/src/backend/commands/analyze.c#L854) — severity chosen at runtime
- [`postgres/src/backend/libpq/auth.c:1227`](https://github.com/postgres/postgres/blob/master/src/backend/libpq/auth.c#L1227) — severity chosen at runtime
- [`postgres/src/backend/libpq/auth.c:1231`](https://github.com/postgres/postgres/blob/master/src/backend/libpq/auth.c#L1231) — severity chosen at runtime
- [`postgres/src/backend/libpq/be-gssapi-common.c:91`](https://github.com/postgres/postgres/blob/master/src/backend/libpq/be-gssapi-common.c#L91) — COMMERROR
- [`postgres/src/backend/parser/parse_agg.c:613`](https://github.com/postgres/postgres/blob/master/src/backend/parser/parse_agg.c#L613) — ERROR
- [`postgres/src/backend/parser/parse_agg.c:1058`](https://github.com/postgres/postgres/blob/master/src/backend/parser/parse_agg.c#L1058) — ERROR
- [`postgres/src/backend/parser/parse_expr.c:604`](https://github.com/postgres/postgres/blob/master/src/backend/parser/parse_expr.c#L604) — ERROR
- [`postgres/src/backend/parser/parse_expr.c:1905`](https://github.com/postgres/postgres/blob/master/src/backend/parser/parse_expr.c#L1905) — ERROR
- [`postgres/src/backend/parser/parse_func.c:2806`](https://github.com/postgres/postgres/blob/master/src/backend/parser/parse_func.c#L2806) — ERROR
- [`postgres/src/backend/postmaster/postmaster.c:891`](https://github.com/postgres/postgres/blob/master/src/backend/postmaster/postmaster.c#L891) — DEBUG3
- [`postgres/src/backend/replication/slot.c:281`](https://github.com/postgres/postgres/blob/master/src/backend/replication/slot.c#L281) — severity chosen at runtime
- [`postgres/src/backend/storage/file/fd.c:1249`](https://github.com/postgres/postgres/blob/master/src/backend/storage/file/fd.c#L1249) — LOG
- [`postgres/src/backend/tcop/postgres.c:5342`](https://github.com/postgres/postgres/blob/master/src/backend/tcop/postgres.c#L5342) — LOG
- [`postgres/src/backend/utils/adt/xml.c:2082`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/xml.c#L2082) — severity chosen at runtime
- [`postgres/src/backend/utils/adt/xml.c:2296`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/xml.c#L2296) — WARNING
- [`postgres/src/backend/utils/adt/xml.c:2301`](https://github.com/postgres/postgres/blob/master/src/backend/utils/adt/xml.c#L2301) — NOTICE
- [`postgres/src/backend/utils/init/postinit.c:324`](https://github.com/postgres/postgres/blob/master/src/backend/utils/init/postinit.c#L324) — LOG
- [`postgres/src/backend/utils/init/postinit.c:1556`](https://github.com/postgres/postgres/blob/master/src/backend/utils/init/postinit.c#L1556) — WARNING
- [`postgres/src/backend/utils/misc/guc.c:6694`](https://github.com/postgres/postgres/blob/master/src/backend/utils/misc/guc.c#L6694) — severity chosen at runtime
- [`postgres/src/backend/utils/misc/guc.c:6728`](https://github.com/postgres/postgres/blob/master/src/backend/utils/misc/guc.c#L6728) — severity chosen at runtime
- [`postgres/src/backend/utils/misc/guc.c:6762`](https://github.com/postgres/postgres/blob/master/src/backend/utils/misc/guc.c#L6762) — severity chosen at runtime
- [`postgres/src/backend/utils/misc/guc.c:6805`](https://github.com/postgres/postgres/blob/master/src/backend/utils/misc/guc.c#L6805) — severity chosen at runtime
- [`postgres/src/backend/utils/misc/guc.c:6846`](https://github.com/postgres/postgres/blob/master/src/backend/utils/misc/guc.c#L6846) — severity chosen at runtime
- [`postgres/src/bin/pg_basebackup/pg_basebackup.c:2236`](https://github.com/postgres/postgres/blob/master/src/bin/pg_basebackup/pg_basebackup.c#L2236) — FATAL
- [`postgres/src/bin/pg_basebackup/streamutil.c:89`](https://github.com/postgres/postgres/blob/master/src/bin/pg_basebackup/streamutil.c#L89) — FATAL
- [`postgres/src/bin/pg_basebackup/streamutil.c:204`](https://github.com/postgres/postgres/blob/master/src/bin/pg_basebackup/streamutil.c#L204) — ERROR
- [`postgres/src/bin/pg_dump/connectdb.c:83`](https://github.com/postgres/postgres/blob/master/src/bin/pg_dump/connectdb.c#L83) — FATAL
- [`postgres/src/bin/pg_dump/connectdb.c:174`](https://github.com/postgres/postgres/blob/master/src/bin/pg_dump/connectdb.c#L174) — FATAL
- [`postgres/src/bin/pg_dump/pg_backup_db.c:203`](https://github.com/postgres/postgres/blob/master/src/bin/pg_dump/pg_backup_db.c#L203) — INFO
- [`postgres/src/bin/pg_dump/pg_dump.c:943`](https://github.com/postgres/postgres/blob/master/src/bin/pg_dump/pg_dump.c#L943) — FATAL
- [`postgres/src/bin/pg_dump/pg_dump_sort.c:1479`](https://github.com/postgres/postgres/blob/master/src/bin/pg_dump/pg_dump_sort.c#L1479) — WARNING
- [`postgres/src/bin/pg_dump/pg_dump_sort.c:1499`](https://github.com/postgres/postgres/blob/master/src/bin/pg_dump/pg_dump_sort.c#L1499) — WARNING
- [`postgres/src/bin/pg_rewind/pg_rewind.c:316`](https://github.com/postgres/postgres/blob/master/src/bin/pg_rewind/pg_rewind.c#L316) — FATAL
- [`postgres/src/bin/pg_upgrade/util.c:337`](https://github.com/postgres/postgres/blob/master/src/bin/pg_upgrade/util.c#L337) — FATAL
- [`postgres/src/bin/pg_waldump/pg_waldump.c:631`](https://github.com/postgres/postgres/blob/master/src/bin/pg_waldump/pg_waldump.c#L631) — FATAL
- [`postgres/src/bin/pgbench/pgbench.c:1518`](https://github.com/postgres/postgres/blob/master/src/bin/pgbench/pgbench.c#L1518) — ERROR
- [`postgres/src/bin/pgbench/pgbench.c:1581`](https://github.com/postgres/postgres/blob/master/src/bin/pgbench/pgbench.c#L1581) — ERROR
- [`postgres/src/bin/pgbench/pgbench.c:3105`](https://github.com/postgres/postgres/blob/master/src/bin/pgbench/pgbench.c#L3105) — ERROR
- [`postgres/src/bin/pgbench/pgbench.c:3659`](https://github.com/postgres/postgres/blob/master/src/bin/pgbench/pgbench.c#L3659) — INFO
- [`postgres/src/bin/pgbench/pgbench.c:4387`](https://github.com/postgres/postgres/blob/master/src/bin/pgbench/pgbench.c#L4387) — DEBUG
- [`postgres/src/bin/pgbench/pgbench.c:5597`](https://github.com/postgres/postgres/blob/master/src/bin/pgbench/pgbench.c#L5597) — ERROR
- [`postgres/src/bin/psql/command.c:1657`](https://github.com/postgres/postgres/blob/master/src/bin/psql/command.c#L1657) — ERROR
- [`postgres/src/bin/psql/command.c:2597`](https://github.com/postgres/postgres/blob/master/src/bin/psql/command.c#L2597) — INFO
- [`postgres/src/bin/psql/command.c:4076`](https://github.com/postgres/postgres/blob/master/src/bin/psql/command.c#L4076) — ERROR
- [`postgres/src/bin/psql/command.c:4274`](https://github.com/postgres/postgres/blob/master/src/bin/psql/command.c#L4274) — INFO
- [`postgres/src/bin/psql/command.c:6552`](https://github.com/postgres/postgres/blob/master/src/bin/psql/command.c#L6552) — ERROR
- [`postgres/src/bin/psql/common.c:233`](https://github.com/postgres/postgres/blob/master/src/bin/psql/common.c#L233) — INFO
- [`postgres/src/bin/psql/common.c:282`](https://github.com/postgres/postgres/blob/master/src/bin/psql/common.c#L282) — INFO
- [`postgres/src/bin/psql/common.c:457`](https://github.com/postgres/postgres/blob/master/src/bin/psql/common.c#L457) — INFO
- [`postgres/src/bin/psql/common.c:1180`](https://github.com/postgres/postgres/blob/master/src/bin/psql/common.c#L1180) — INFO
- [`postgres/src/bin/psql/common.c:1198`](https://github.com/postgres/postgres/blob/master/src/bin/psql/common.c#L1198) — INFO
- [`postgres/src/bin/psql/common.c:1266`](https://github.com/postgres/postgres/blob/master/src/bin/psql/common.c#L1266) — INFO
- [`postgres/src/bin/psql/common.c:1378`](https://github.com/postgres/postgres/blob/master/src/bin/psql/common.c#L1378) — INFO
- [`postgres/src/bin/psql/common.c:1416`](https://github.com/postgres/postgres/blob/master/src/bin/psql/common.c#L1416) — INFO
- [`postgres/src/bin/psql/common.c:1720`](https://github.com/postgres/postgres/blob/master/src/bin/psql/common.c#L1720) — INFO
- [`postgres/src/bin/psql/common.c:1800`](https://github.com/postgres/postgres/blob/master/src/bin/psql/common.c#L1800) — INFO
- [`postgres/src/bin/psql/copy.c:486`](https://github.com/postgres/postgres/blob/master/src/bin/psql/copy.c#L486) — INFO
- [`postgres/src/bin/psql/copy.c:731`](https://github.com/postgres/postgres/blob/master/src/bin/psql/copy.c#L731) — INFO
- [`postgres/src/bin/psql/large_obj.c:157`](https://github.com/postgres/postgres/blob/master/src/bin/psql/large_obj.c#L157) — INFO
- [`postgres/src/bin/psql/large_obj.c:192`](https://github.com/postgres/postgres/blob/master/src/bin/psql/large_obj.c#L192) — INFO
- [`postgres/src/bin/psql/large_obj.c:254`](https://github.com/postgres/postgres/blob/master/src/bin/psql/large_obj.c#L254) — INFO
- [`postgres/src/bin/psql/startup.c:310`](https://github.com/postgres/postgres/blob/master/src/bin/psql/startup.c#L310) — ERROR
- [`postgres/src/bin/scripts/pg_isready.c:146`](https://github.com/postgres/postgres/blob/master/src/bin/scripts/pg_isready.c#L146) — ERROR
- [`postgres/src/common/scram-common.c:286`](https://github.com/postgres/postgres/blob/master/src/common/scram-common.c#L286) — ERROR
- [`postgres/src/common/scram-common.c:302`](https://github.com/postgres/postgres/blob/master/src/common/scram-common.c#L302) — ERROR
- [`postgres/src/common/scram-common.c:319`](https://github.com/postgres/postgres/blob/master/src/common/scram-common.c#L319) — ERROR
- [`postgres/src/fe_utils/connect_utils.c:116`](https://github.com/postgres/postgres/blob/master/src/fe_utils/connect_utils.c#L116) — FATAL
- [`postgres/src/fe_utils/recovery_gen.c:215`](https://github.com/postgres/postgres/blob/master/src/fe_utils/recovery_gen.c#L215) — FATAL
- [`postgres/src/pl/plpgsql/src/pl_exec.c:3942`](https://github.com/postgres/postgres/blob/master/src/pl/plpgsql/src/pl_exec.c#L3942) — severity chosen at runtime
- [`postgres/src/pl/plpgsql/src/pl_exec.c:3998`](https://github.com/postgres/postgres/blob/master/src/pl/plpgsql/src/pl_exec.c#L3998) — ERROR
- [`postgres/src/pl/plpython/plpy_elog.c:123`](https://github.com/postgres/postgres/blob/master/src/pl/plpython/plpy_elog.c#L123) — severity chosen at runtime
- [`postgres/src/pl/plpython/plpy_plpymodule.c:497`](https://github.com/postgres/postgres/blob/master/src/pl/plpython/plpy_plpymodule.c#L497) — severity chosen at runtime
- [`postgres/src/pl/tcl/pltcl.c:1404`](https://github.com/postgres/postgres/blob/master/src/pl/tcl/pltcl.c#L1404) — ERROR
- [`postgres/src/pl/tcl/pltcl.c:1898`](https://github.com/postgres/postgres/blob/master/src/pl/tcl/pltcl.c#L1898) — severity chosen at runtime

## Related

- [invalid regular expression: %s](./invalid-regular-expression-55c554.md)
- [invalid input syntax for type](./invalid-input-syntax-for-type-1b54ae.md)
