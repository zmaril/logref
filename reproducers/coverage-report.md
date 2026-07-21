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
- Tier 2-4 scenarios add **933** new distinct sites
- **Combined: 1178 of 14806 (7.96%)**

## New sites by tier

Attributed to the first scenario that fired each site (no double-counting).

| tier | new sites |
|---|--:|
| Tier 2 — crafted-SQL error corpus + contrib | 740 |
| Tier 3 — config / auth / SSL | 22 |
| Tier 3-4 — multi-session concurrency | 7 |
| Tier 4 — corruption / replication / resource / crash | 164 |

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
| `tier2__30_type_io_numeric_int` | 18 |
| `tier2__31_createtable_view_trigger` | 23 |
| `tier2__31_type_io_datetime` | 6 |
| `tier2__32_adt_arithmetic_overflow` | 14 |
| `tier2__32_type_io_net_geo_bit` | 3 |
| `tier2__33_grant_roles_coerce_dml` | 8 |
| `tier2__33_type_io_json_range_misc` | 11 |
| `tier2__34_guc_vacuum_copy_xml` | 26 |
| `tier2__35_ddl_object_lifecycle` | 24 |
| `tier2__36_constraints_partitioning` | 21 |
| `tier2__37_alter_type_column_tablespace` | 25 |
| `tier2__38_planner_executor_runtime` | 8 |
| `tier2__39_cte_cursors_prepared_lock` | 26 |
| `tier2__40_extensions_setup` | 6 |
| `tier2__41_contrib_input_errors` | 5 |
| `tier2__42_contrib_inspection` | 28 |
| `tier2__43_contrib_fdw_indexam` | 9 |
| `tier2__44_functions_operators_aggregates` | 38 |
| `tier2__45_create_routines` | 85 |
| `tier2__46_grant_revoke_privtypes` | 9 |
| `tier2__47_permission_denied_objtypes` | 2 |
| `tier2__48_roles_membership_reserved` | 8 |
| `tier2__49_rls_policies_defaclr` | 13 |
| `tier2__50_txn_control_savepoints` | 10 |
| `tier2__51_twophase_prepare` | 5 |
| `tier2__52_locks_rowmarks_advisory` | 7 |
| `tier2__53_vacuum_cluster_concurrency_ddl` | 5 |
| `tier2__62_contrib_type_input_deep` | 13 |
| `tier2__63_contrib_dict_trigger` | 11 |
| `tier2__64_contrib_inspect_deep` | 14 |
| `tier2__65_contrib_fdw_dblink_crypto` | 15 |
| `tier34__50_txn_concurrency` | 7 |
| `tier3__auth_ssl` | 13 |
| `tier3__bad_config` | 2 |
| `tier3__bad_hba` | 7 |
| `tier4__58_repl_physical_cascade` | 3 |
| `tier4__58_repl_physical_primary` | 7 |
| `tier4__58_repl_physical_standby` | 1 |
| `tier4__59_repl_slots_primary` | 5 |
| `tier4__59_repl_slots_standby` | 2 |
| `tier4__61_pub_sub_pub_standby` | 5 |
| `tier4__61_pub_sub_subscriber` | 4 |
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
| ERROR | 707 |
| LOG | 49 |
| DEBUG1 | 46 |
| DEBUG2 | 32 |
| elevel | 23 |
| DEBUG4 | 19 |
| WARNING | 13 |
| NOTICE | 12 |
| FATAL | 10 |
| DEBUG3 | 9 |
| log_replication_commands ? LOG : DEBUG1 | 3 |
| IsPostmasterEnvironment ? LOG : NOTICE | 2 |
| LogicalDecodingLogLevel() | 2 |
| emode_for_corrupt_record(emode, xlogreader->EndRecPtr) | 1 |
| flags & PIV_LOG_WARNING ? WARNING : LOG | 1 |
| level | 1 |
| stmt->elog_level | 1 |
| trace_level | 1 |
| wait_result_is_any_signal(rc, true) ? FATAL : DEBUG2 | 1 |

## Top source files by new sites

Ranked by new sites reproduced. Per-file catalog denominators are not recomputed here (no Postgres rebuild this pass).

| file | new sites |
|---|--:|
| `postgres/src/backend/commands/tablecmds.c` | 64 |
| `postgres/src/backend/commands/functioncmds.c` | 42 |
| `postgres/src/backend/parser/parse_func.c` | 38 |
| `postgres/src/backend/commands/typecmds.c` | 27 |
| `postgres/src/backend/access/transam/xlogrecovery.c` | 26 |
| `postgres/src/backend/access/transam/xlog.c` | 20 |
| `postgres/src/backend/parser/parse_cte.c` | 19 |
| `postgres/src/backend/postmaster/postmaster.c` | 17 |
| `postgres/src/backend/catalog/aclchk.c` | 13 |
| `postgres/src/backend/commands/copy.c` | 12 |
| `postgres/src/backend/commands/indexcmds.c` | 12 |
| `postgres/src/backend/utils/misc/guc.c` | 12 |
| `postgres/src/backend/catalog/pg_operator.c` | 11 |
| `postgres/src/backend/commands/aggregatecmds.c` | 11 |
| `postgres/src/backend/parser/parse_agg.c` | 11 |
| `postgres/src/backend/utils/adt/jsonpath_exec.c` | 11 |
| `postgres/src/backend/utils/adt/timestamp.c` | 11 |
| `postgres/src/backend/catalog/namespace.c` | 10 |
| `postgres/contrib/postgres_fdw/option.c` | 9 |
| `postgres/src/backend/commands/subscriptioncmds.c` | 9 |
| `postgres/src/backend/commands/user.c` | 9 |
| `postgres/src/backend/parser/parse_clause.c` | 9 |
| `postgres/src/backend/parser/parse_utilcmd.c` | 9 |
| `postgres/src/backend/tcop/postgres.c` | 9 |
| `postgres/src/backend/utils/adt/int.c` | 9 |

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

## Frontend client-tool sites (message-text matched)

The sites above are all *backend* sites: a running server prints them to
`jsonlog`, which carries `file_name:file_line_num`, so the catalog join is an
exact `file:line` match. Postgres' **frontend** client tools (`pg_dump`,
`pgbench`, `initdb`, the `scripts/` wrappers, the `pg_basebackup` family, ...)
are different. They call `pg_log_error` / `pg_fatal`, which write plain text to
stderr — `progname: error: <message>` — with **no** source location. The
`file:line` join can never reach them, so every one of these sites sat
unreproduced.

**Method.** We reproduce them the only honest way message text allows: run each
tool straight into a real option-parsing, value-validation, or object-filter
error (driver `frontend-run.sh`, scenarios 66–69), capture its stderr, and
attribute each captured line to a **unique** catalog frontend site. The matcher
(`frontend-coverage.py`) converts each candidate site's printf format string to
an anchored regex, scopes candidates to the tool's own source file(s) ∪
`fe_utils` ∪ `common`, and credits a line **only when exactly one** candidate
matches. Zero or multiple matches are recorded as unmatched / ambiguous and not
counted. Sites whose format string carries fewer than three literal
alphanumeric characters (e.g. `pg_fatal("%s")`, `"%s: %s"`, `"%m"`) are
excluded up front as unidentifiable-by-message: any output could have come from
them, so keeping them would only poison every line into ambiguity. This is a
by-message attribution, not a by-location one, and it is labelled as such: each
merged entry carries `"kind": "frontend"` and `"match": "message-text"` (and
`"sqlstates": null`, since frontend sites have no SQLSTATE).

**Result: 73 new distinct sites**, across 21 tools, none previously reproduced.
By scenario group:

| scenario group | tools | new sites |
|---|---|--:|
| 66 — dump / restore / dumpall / upgrade | `pg_dump` `pg_restore` `pg_dumpall` `pg_upgrade` | 14 |
| 67 — physical / backup tools | `pg_basebackup` `pg_receivewal` `pg_recvlogical` `pg_rewind` `pg_combinebackup` `pg_verifybackup` `pg_waldump` `pg_checksums` `pg_amcheck` | 29 |
| 68 — pgbench + psql | `pgbench` `psql` | 8 |
| 69 — scripts + initdb + pg_ctl | `initdb` `pg_ctl` `reindexdb` `vacuumdb` `clusterdb` `createdb` `dropdb` `createuser` `dropuser` | 22 |

By tool:

| tool | new | tool | new |
|---|--:|---|--:|
| `pg_dump` | 13 | `pg_receivewal` | 3 |
| `pg_basebackup` | 7 | `pg_recvlogical` | 3 |
| `pgbench` | 6 | `reindexdb` | 3 |
| `initdb` | 5 | `createuser` | 2 |
| `pg_waldump` | 5 | `pg_amcheck` | 2 |
| `createdb` | 3 | `pg_checksums` | 2 |
| `dropdb` | 3 | `pg_rewind` | 2 |
| `dropuser` | 3 | `pg_verifybackup` | 2 |
| `pg_combinebackup` | 3 | `psql` | 2 |
| `clusterdb` | 1 | `vacuumdb` | 2 |
| `pg_restore` | 1 | | |

### Honest limits

A message-based join reaches less than a location-based one, on purpose. What it
cannot attribute, and why:

- **psql meta-command errors** (`\pset: ...`, `\if`/`\elif` misuse) — psql prints
  these **bare**, with no `progname: error:` prefix, so the line filter can't even
  recognise them as emissions, let alone attribute them. Only psql's startup-time
  errors (e.g. `psql -P format=nonsense`) carry the prefix and are covered.
- **libpq `"%s"` connection passthroughs** — a failed connection surfaces the
  server / libpq text through a bare `%s` site with no literal content of its own;
  excluded as unidentifiable-by-message.
- **Ambiguous in-file messages** — where two sites in one tool share a format
  (the `Try "%s --help" for more information.` hint every tool emits; `vacuumdb`'s
  duplicate mutually-exclusive option checks), no single candidate wins, so the
  line is dropped as ambiguous rather than guessed.
- **`pg_amcheck` `log_no_match` sites** — its pattern-not-found diagnostics route
  through a helper the extractor doesn't flag as a frontend log site, so they are
  not candidates.

These exclusions are the price of honesty: every one of the 73 is a line the tool
actually printed, matched to exactly one catalog site by its message.

### Measurement provenance

The frontend catalog and captures were produced from a Postgres **HEAD build at
`54cd6fc` from source** (the campaign's canonical commit). That local extraction
found **14,856** catalog sites — 50 more than the 14,806 this report uses as the
join denominator. The difference is a Semgrep-version artifact in the extractor,
not a change in Postgres: per-site line numbers are exact and stable, so the
extra 50 affect only the total count. The denominator therefore stays **14,806**
across the whole campaign, and these 73 are counted against it.
