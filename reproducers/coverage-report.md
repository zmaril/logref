# Reproducer coverage report

The Validate stage of LogRef (see `notes/design.md` §4). A HEAD build of
Postgres is driven through two families of scenarios and its `jsonlog`
output captured; each line's `file_name:file_line_num` is joined against the
extracted catalog by `(basename, line)`.

- **Tier 1-2** (`scenarios/`, driver `run.sh`): one stock cluster, crafted
  SQL — boot/lifecycle LOGs and user-triggerable ERRORs.
- **Tier 3-4** (`env/`, driver `env-run.sh`): deliberately hostile
  environments — broken config, rejecting auth, corrupted files, a
  primary/standby pair, exhausted resources, an un-clean shutdown.

- Postgres HEAD commit: `54cd6fc83176d7c03abf95554aef26b0b24acc7d`
- Catalog sites: **14806**
- Tier 1-2 baseline (exact file:line): **245** (1.65%)
- Tier 3-4 adds **117** new distinct sites
- **Combined: 362 of 14806 (2.44%)**

## New sites by tier (Tier 3-4)

Attributed to the first tier that fired each site (no double-counting).

| tier | new sites |
|---|--:|
| Tier 3 — config / auth / SSL | 29 |
| Tier 4 — corruption / replication / resource / crash | 88 |

## New sites by scenario

| scenario | new sites (excl. baseline) |
|---|--:|
| `tier3__auth_ssl` | 16 |
| `tier3__bad_config` | 11 |
| `tier3__bad_hba` | 13 |
| `tier4__corruption` | 4 |
| `tier4__crash_recovery` | 11 |
| `tier4__disk_full` | 2 |
| `tier4__logical_publisher` | 25 |
| `tier4__logical_subscriber` | 19 |
| `tier4__replication_primary` | 14 |
| `tier4__replication_standby` | 47 |
| `tier4__resource_timeouts` | 6 |

## New sites by severity

| level | new sites |
|---|--:|
| DEBUG1 | 25 |
| LOG | 25 |
| DEBUG2 | 21 |
| elevel | 13 |
| DEBUG4 | 13 |
| DEBUG3 | 5 |
| FATAL | 4 |
| log_replication_commands ? LOG : DEBUG1 | 3 |
| NOTICE | 2 |
| LogicalDecodingLogLevel() | 2 |
| trace_level | 1 |
| emode_for_corrupt_record(emode, xlogreader->EndRecPtr) | 1 |
| flags & PIV_LOG_WARNING ? WARNING : LOG | 1 |
| ERROR | 1 |

## Top source files by new sites

| file | new | in catalog |
|---|--:|--:|
| `postgres/src/backend/access/transam/xlogrecovery.c` | 18 | 115 |
| `postgres/src/backend/access/transam/xlog.c` | 9 | 140 |
| `postgres/src/backend/replication/logical/snapbuild.c` | 7 | 50 |
| `postgres/src/backend/storage/ipc/procarray.c` | 6 | 25 |
| `postgres/src/backend/utils/misc/guc.c` | 6 | 107 |
| `postgres/src/backend/replication/logical/worker.c` | 6 | 78 |
| `postgres/src/backend/postmaster/postmaster.c` | 6 | 91 |
| `postgres/src/backend/libpq/hba.c` | 5 | 52 |
| `postgres/src/backend/replication/walsender.c` | 5 | 54 |
| `postgres/src/backend/libpq/be-secure-openssl.c` | 5 | 67 |
| `postgres/src/backend/replication/walreceiver.c` | 4 | 26 |
| `postgres/src/backend/replication/logical/logical.c` | 4 | 40 |
| `postgres/src/backend/libpq/auth.c` | 3 | 81 |
| `postgres/src/backend/storage/lmgr/proc.c` | 3 | 17 |
| `postgres/src/backend/commands/subscriptioncmds.c` | 2 | 81 |
| `postgres/src/backend/utils/cache/inval.c` | 2 | 10 |
| `postgres/src/backend/postmaster/bgworker.c` | 2 | 24 |
| `postgres/src/backend/libpq/auth-sasl.c` | 2 | 5 |
| `postgres/src/backend/replication/slot.c` | 2 | 57 |
| `postgres/src/backend/backup/basebackup.c` | 2 | 68 |
| `postgres/src/backend/utils/fmgr/dfmgr.c` | 1 | 13 |
| `postgres/src/backend/replication/pgoutput/pgoutput.c` | 1 | 28 |
| `postgres/src/backend/tcop/backend_startup.c` | 1 | 32 |
| `postgres/src/backend/storage/ipc/standby.c` | 1 | 10 |
| `postgres/src/backend/utils/adt/array_typanalyze.c` | 1 | 4 |

## Sample new matches (captured jsonlog line -> catalog site)

- `postgres/src/backend/access/transam/xlog.c:2784` [DEBUG2/-] — updated min recovery point to %X/%08X on timeline %u  _(via tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlog.c:3887` [DEBUG2/-] — removing all temporary WAL segments  _(via tier4__crash_recovery, tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlog.c:4012` [DEBUG2/-] — attempting to remove WAL segments newer than log file %s  _(via tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlog.c:4083` [DEBUG2/-] — recycled write-ahead log file "%s"  _(via tier4__crash_recovery, tier4__replication_primary, tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlog.c:4225` [DEBUG2/-] — removing WAL backup history file "%s"  _(via tier4__replication_primary)_
- `postgres/src/backend/access/transam/xlog.c:5928` [LOG/-] — database system was interrupted; last known up at %s  _(via tier4__crash_recovery, tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlog.c:6217` [DEBUG1/-] — initializing for hot standby  _(via tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlog.c:6380` [LOG/-] — selected new timeline ID: %u  _(via tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlog.c:6413` [LOG/-] — archive recovery complete  _(via tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlogrecovery.c:561` [LOG/-] — starting backup recovery with redo LSN %X/%08X, checkpoint LSN %X/%08…  _(via tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlogrecovery.c:577` [DEBUG1/-] — checkpoint record is at %X/%08X  _(via tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlogrecovery.c:760` [LOG/-] — entering standby mode  _(via tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlogrecovery.c:894` [LOG/-] — database system was not properly shut down; automatic recovery in pro…  _(via tier4__crash_recovery)_
- `postgres/src/backend/access/transam/xlogrecovery.c:1259` [DEBUG1/-] — backup time %s in file "%s"  _(via tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlogrecovery.c:1264` [DEBUG1/-] — backup label %s in file "%s"  _(via tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlogrecovery.c:1281` [DEBUG1/-] — backup timeline %u in file "%s"  _(via tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlogrecovery.c:1699` [LOG/-] — redo starts at %X/%08X  _(via tier4__crash_recovery, tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlogrecovery.c:1848` [LOG/-] — redo done at %X/%08X system usage: %s  _(via tier4__crash_recovery, tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlogrecovery.c:1854` [LOG/-] — last completed transaction was at log time %s  _(via tier4__replication_standby)_
- `postgres/src/backend/access/transam/xlogrecovery.c:2093` [DEBUG1/-] — end of backup record reached  _(via tier4__replication_standby)_

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
- **amcheck corruption reports** — `contrib/amcheck` is not installed in
  this build, and its findings return as result rows, not log lines, so they
  never reach the jsonlog join regardless.
- **Archiver / `archive_command` failures** and most I/O-error paths in
  `md.c`/`fd.c` — need a failing archive target or an injected read fault.
- **Startup-time GUC/`postgresql.conf` fatals** — these print to stderr
  before the logging collector starts, so they are not in the jsonlog; only
  the SIGHUP reload path (captured here) logs structurally.
