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

## What it means

This is not one message but a passthrough: the entire text is a single `%s` placeholder, so the real content is assembled at runtime and inserted whole. Postgres uses this shape in dozens of places to relay a string it built elsewhere — a formatted sub-error, a message from a library, a generated report — where the wording is not known statically. The severity and SQLSTATE therefore vary by call site rather than being fixed by the text.

## When it happens

Emitted from many unrelated call sites across the tree, at every severity from `DEBUG` to `FATAL`. Because the literal is just `%s`, the static catalog cannot tell you what any given occurrence will actually say — the words come from the argument at that specific site.

## How to fix

There is nothing to act on from the format string alone. A passthrough line must be diagnosed by its rendered content and its source location: with `log_error_verbosity = verbose`, the `file_name`/`file_line_num` in `jsonlog` pin down which of these call sites emitted it, and the reference page for that specific site (once enriched) carries the real guidance. This page exists mainly to document the passthrough pattern itself.

## Related

- [invalid regular expression: %s](./invalid-regular-expression-55c554.md)
- [invalid input syntax for type](./invalid-input-syntax-for-type-1b54ae.md)
