# Reproducer coverage report

The Validate stage of LogRef (see `notes/design.md` §4). A HEAD build of
Postgres is driven through several families of scenarios and its `jsonlog`
output captured; each line's `file_name:file_line_num` is joined against the
extracted catalog by `(basename, line)`.

- **Baseline — Tier 1** (`scenarios/00`-`14`, driver `run.sh`): one stock
  cluster's boot/lifecycle LOGs and the first crafted-SQL error batch.
- **Tier 2** (`scenarios/15`-`43`, driver `run.sh`): a broad, systematic
  crafted-SQL error corpus — every built-in type, the DDL/catalog surface,
  function/operator resolution, query semantics, plpgsql runtime, and the
  installed `contrib` extensions' input/validation paths.
- **Tier 3-4** (`env/`, driver `env-run.sh`): deliberately hostile
  environments — broken config, rejecting auth, corrupted files, a
  primary/standby pair, exhausted resources, an un-clean shutdown.

- Postgres HEAD commit: `54cd6fc83176d7c03abf95554aef26b0b24acc7d`
- Catalog sites: **14806**
- Baseline (Tier 1, exact file:line): **245** (1.65%)
- Tier 2-4 scenarios add **522** new distinct sites
- **Combined: 767 of 14806 (5.18%)**

## New sites by tier

Attributed to the first scenario that fired each site (no double-counting).

| tier | new sites |
|---|--:|
| Tier 2 — crafted-SQL error corpus + contrib | 363 |
| Tier 3 — config / auth / SSL | 22 |
| Tier 4 — corruption / replication / resource / crash | 137 |

## New sites by scenario

| scenario | new sites (excl. baseline) |
|---|--:|
| `tier2__15_types_extended` | 11 |
| `tier2__16_datetime_extended` | 3 |
| `tier2__17_strings_format_regex` | 9 |
| `tier2__18_arrays_ranges_composite` | 6 |
| `tier2__19_json_sqljson` | 13 |
| `tier2__20_network_geo_enum_ts_xml` | 9 |
| `tier2__21_ddl_objects` | 16 |
| `tier2__22_system_admin_funcs` | 31 |
| `tier2__23_query_semantics_extended` | 17 |
| `tier2__24_txn_copy_cursor` | 19 |
| `tier2__25_ddl_objects_more` | 29 |
| `tier2__26_roles_acl_plpgsql` | 12 |
| `tier2__27_alter_table` | 25 |
| `tier2__28_typecmds_domain_comment` | 20 |
| `tier2__29_func_index_extension_ddl` | 24 |
| `tier2__31_createtable_view_trigger` | 23 |
| `tier2__32_adt_arithmetic_overflow` | 14 |
| `tier2__33_grant_roles_coerce_dml` | 8 |
| `tier2__34_guc_vacuum_copy_xml` | 26 |
| `tier2__40_extensions_setup` | 6 |
| `tier2__41_contrib_input_errors` | 5 |
| `tier2__42_contrib_inspection` | 28 |
| `tier2__43_contrib_fdw_indexam` | 9 |
| `tier3__auth_ssl` | 13 |
| `tier3__bad_config` | 2 |
| `tier3__bad_hba` | 7 |
| `tier4__checkpoint_bgwriter` | 21 |
| `tier4__corruption` | 1 |
| `tier4__crash_recovery` | 3 |
| `tier4__disk_full` | 2 |
| `tier4__logical_publisher` | 20 |
| `tier4__logical_subscriber` | 14 |
| `tier4__pitr_beforeconsistent` | 10 |
| `tier4__pitr_primary` | 2 |
| `tier4__pitr_restore` | 2 |
| `tier4__pitr_unreached` | 3 |
| `tier4__replication_primary` | 4 |
| `tier4__replication_standby` | 41 |
| `tier4__resource_timeouts` | 3 |
| `tier4__standby_conflict` | 4 |
| `tier4__wal_control_states` | 7 |

## New sites by severity

| level | new sites |
|---|--:|
| ERROR | 337 |
| LOG | 41 |
| DEBUG1 | 36 |
| DEBUG2 | 31 |
| DEBUG4 | 19 |
| elevel | 18 |
| DEBUG3 | 8 |
| FATAL | 8 |
| WARNING | 7 |
| NOTICE | 5 |
| log_replication_commands ? LOG : DEBUG1 | 3 |
| IsPostmasterEnvironment ? LOG : NOTICE | 2 |
| LogicalDecodingLogLevel() | 2 |
| emode_for_corrupt_record(emode, xlogreader->EndRecPtr) | 1 |
| flags & PIV_LOG_WARNING ? WARNING : LOG | 1 |
| stmt->elog_level | 1 |
| trace_level | 1 |
| wait_result_is_any_signal(rc, true) ? FATAL : DEBUG2 | 1 |

## Top source files by new sites

Ranked by new sites reproduced. Per-file catalog denominators are not recomputed here (no Postgres rebuild this pass).

| file | new sites |
|---|--:|
| `postgres/src/backend/commands/tablecmds.c` | 27 |
| `postgres/src/backend/access/transam/xlogrecovery.c` | 24 |
| `postgres/src/backend/postmaster/postmaster.c` | 17 |
| `postgres/src/backend/access/transam/xlog.c` | 16 |
| `postgres/src/backend/commands/copy.c` | 12 |
| `postgres/src/backend/commands/indexcmds.c` | 11 |
| `postgres/src/backend/commands/functioncmds.c` | 10 |
| `postgres/src/backend/utils/adt/timestamp.c` | 9 |
| `postgres/src/backend/utils/misc/guc.c` | 8 |
| `postgres/src/backend/replication/logical/snapbuild.c` | 7 |
| `postgres/src/backend/catalog/namespace.c` | 6 |
| `postgres/src/backend/commands/extension.c` | 6 |
| `postgres/src/backend/commands/sequence.c` | 6 |
| `postgres/src/backend/commands/subscriptioncmds.c` | 6 |
| `postgres/src/backend/commands/trigger.c` | 6 |
| `postgres/src/backend/commands/vacuum.c` | 6 |
| `postgres/src/backend/parser/parse_func.c` | 6 |
| `postgres/src/backend/parser/parse_utilcmd.c` | 6 |
| `postgres/src/backend/replication/logical/worker.c` | 6 |
| `postgres/src/backend/storage/ipc/procarray.c` | 6 |
| `postgres/src/backend/commands/typecmds.c` | 5 |
| `postgres/src/backend/libpq/be-secure-openssl.c` | 5 |
| `postgres/src/backend/libpq/hba.c` | 5 |
| `postgres/src/backend/replication/walsender.c` | 5 |
| `postgres/src/backend/tcop/postgres.c` | 5 |

## Sample new matches (captured jsonlog line -> catalog site)

- `postgres/contrib/amcheck/verify_heapam.c:337` [ERROR/ERRCODE_WRONG_OBJECT_TYPE] — cannot check relation "%s"  _(via tier2__43_contrib_fdw_indexam)_
- `postgres/contrib/amcheck/verify_heapam.c:389` [ERROR/ERRCODE_INVALID_PARAMETER_VALUE] — starting block number must be between 0 and %u  _(via tier2__43_contrib_fdw_indexam)_
- `postgres/contrib/dblink/dblink.c:187` [ERROR/ERRCODE_CONNECTION_DOES_NOT_EXIST] — connection "%s" not available  _(via tier2__43_contrib_fdw_indexam)_
- `postgres/contrib/dblink/dblink.c:235` [ERROR/ERRCODE_SQLCLIENT_UNABLE_TO_ESTABLISH_SQLCONNECTION] — could not establish connection  _(via tier2__43_contrib_fdw_indexam)_
- `postgres/contrib/dblink/dblink.c:337` [ERROR/ERRCODE_SQLCLIENT_UNABLE_TO_ESTABLISH_SQLCONNECTION] — could not establish connection  _(via tier2__43_contrib_fdw_indexam)_
- `postgres/contrib/fuzzystrmatch/fuzzystrmatch.c:292` [ERROR/ERRCODE_ZERO_LENGTH_CHARACTER_STRING] — output cannot be empty string  _(via tier2__41_contrib_input_errors)_
- `postgres/contrib/hstore/hstore_io.c:668` [ERROR/ERRCODE_ARRAY_SUBSCRIPT_ERROR] — arrays must have same bounds  _(via tier2__41_contrib_input_errors)_
- `postgres/contrib/hstore/hstore_io.c:1013` [ERROR/ERRCODE_DATATYPE_MISMATCH] — first argument must be a rowtype  _(via tier2__41_contrib_input_errors)_
- `postgres/contrib/intarray/_int_op.c:223` [ERROR/ERRCODE_INVALID_PARAMETER_VALUE] — second parameter must be "ASC" or "DESC"  _(via tier2__41_contrib_input_errors)_
- `postgres/contrib/ltree/ltree_op.c:308` [ERROR/ERRCODE_INVALID_PARAMETER_VALUE] — invalid positions  _(via tier2__41_contrib_input_errors)_
- `postgres/contrib/pageinspect/btreefuncs.c:229` [ERROR/ERRCODE_WRONG_OBJECT_TYPE] — "%s" is not a %s index  _(via tier2__42_contrib_inspection)_
- `postgres/contrib/pageinspect/btreefuncs.c:862` [ERROR/ERRCODE_WRONG_OBJECT_TYPE] — "%s" is not a %s index  _(via tier2__42_contrib_inspection)_
- `postgres/contrib/pageinspect/heapfuncs.c:411` [ERROR/ERRCODE_DATA_CORRUPTED] — end of tuple reached without looking at all its data  _(via tier2__42_contrib_inspection)_
- `postgres/contrib/pageinspect/rawpage.c:162` [ERROR/ERRCODE_WRONG_OBJECT_TYPE] — cannot get raw page from relation "%s"  _(via tier2__42_contrib_inspection)_
- `postgres/contrib/pageinspect/rawpage.c:179` [ERROR/ERRCODE_INVALID_PARAMETER_VALUE] — block number %u is out of range for relation "%s"  _(via tier2__42_contrib_inspection)_
- `postgres/contrib/pageinspect/rawpage.c:223` [ERROR/ERRCODE_INVALID_PARAMETER_VALUE] — invalid page size  _(via tier2__42_contrib_inspection)_
- `postgres/contrib/pg_prewarm/pg_prewarm.c:99` [ERROR/ERRCODE_INVALID_PARAMETER_VALUE] — invalid prewarm type  _(via tier2__42_contrib_inspection)_
- `postgres/contrib/pg_prewarm/pg_prewarm.c:155` [ERROR/ERRCODE_WRONG_OBJECT_TYPE] — relation "%s" does not have storage  _(via tier2__42_contrib_inspection)_
- `postgres/contrib/pg_surgery/heap_surgery.c:112` [ERROR/ERRCODE_WRONG_OBJECT_TYPE] — cannot operate on relation "%s"  _(via tier2__42_contrib_inspection)_
- `postgres/contrib/pg_surgery/heap_surgery.c:171` [NOTICE/ERRCODE_INVALID_PARAMETER_VALUE] — skipping block %u for relation "%s" because the block number is out o…  _(via tier2__42_contrib_inspection)_

## Methodology and honest limits

Every number above is a site the running database actually printed, joined
by exact `file:line`. The captures come from a from-source HEAD build driven
in scratch clusters (Docker daemon unavailable), at `log_min_messages =
debug5` — the same level as the baseline, so the delta is apples-to-apples.

Timing-sensitive scenarios (streaming/logical replication, crash recovery)
vary run-to-run by a handful of DEBUG sites; the figures are from one
representative run. What this environment could **not** reach:

- **OOM / the memory-context dump path** — needs a cgroup memory cap or a
  real allocator failure; not provokable without container limits here.
- **amcheck / pageinspect corruption *reports*** — the `contrib` modules are
  installed and their argument/validation ERROR paths are exercised (Tier 2),
  but a genuine corruption *finding* returns as a result row, not a log line,
  so it never reaches the jsonlog join regardless.
- **Archiver / `archive_command` failures** and most I/O-error paths in
  `md.c`/`fd.c` — need a failing archive target or an injected read fault.
- **Startup-time GUC/`postgresql.conf` fatals** — these print to stderr
  before the logging collector starts, so they are not in the jsonlog; only
  the SIGHUP reload path (captured here) logs structurally.
