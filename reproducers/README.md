# Reproducers — the Validate stage

This directory is LogRef's **Validate stage** (see `notes/design.md` §4). The
extractor gives us a static catalog of every log call site in Postgres. Validate
answers the next question: *which of those sites can we drive a running database
to emit, with ground-truth provenance?*

The approach is deliberately literal. Build Postgres, wire it to log its own
source locations, drive it through a large set of scenarios, capture the log,
and join each captured line back to the catalog by `file:line`. Every number in
`coverage-report.md` is a site we watched the real database print.

## Why HEAD, and why jsonlog

- **Postgres HEAD, from source.** The catalog is extracted from `master`, so the
  cluster is built from `master` too — the emitted strings and their line
  numbers line up with the catalog exactly. `base/Dockerfile` clones the tip of
  `postgres/postgres` and does `configure && make && make install` plus
  `make -C contrib install` (the Tier 2 corpus exercises the contrib modules'
  error paths); nothing is pinned to a released tag.
- **`jsonlog` with verbose errors.** `base/logging.conf` sets
  `log_destination = 'jsonlog'` and `log_error_verbosity = verbose`, so every
  record carries `file_name`, `file_line_num`, `func_name`, `error_severity` and
  `state` (SQLSTATE). Those `file_name` + `file_line_num` fields are the __FILE__
  and __LINE__ of the `ereport`/`elog` call site — the exact join key against the
  catalog's `path` and `line`. The config also turns the surface up
  (`log_min_messages = debug1`, `log_statement = 'all'`, connection/checkpoint/
  autovacuum logging) so lifecycle sites fire alongside the SQL-triggered ones.

## Layout

```
base/Dockerfile     builds Postgres from HEAD, non-root, wired for jsonlog
base/logging.conf   the provenance logging config (appended to postgresql.conf)
scenarios/*.sql     deliberately-wrong statements, grouped by theme (Tiers 1-2)
run.sh              boots the cluster, runs every scenario, joins, writes the report
coverage.py         the catalog join + report generator (Tiers 1-2)

lib.sh              shared cluster-lifecycle helpers (init/start/stop/psql/capture)
sql-caps.sh         per-scenario Tier 2 capture driver (one cap per scenario)
env-run.sh          the Tier 3-4 driver: hostile-environment scenarios
env/Dockerfile      the parametrized env-variant image (extends base)
env/entrypoint.sh   the env image's entrypoint (runs one scenario, captures)
env-coverage.py     the delta join + report generator (Tiers 2-4 over baseline)
coverage-report.md  the committed result (baseline + Tier 2-4 delta)
reproduced-sites.json  machine-readable list of newly-reproduced sites
```

## How to run

Docker path (the shippable one):

```sh
CATALOG=/path/to/pg-log-catalog.jsonl reproducers/run.sh --docker
```

Direct path (used to measure when Docker-in-Docker is unavailable — builds the
same HEAD Postgres on the host and runs it in a scratch dir):

```sh
# build once: git clone --depth 1 https://github.com/postgres/postgres.git \
#   && ./configure --prefix=<install> && make && make install \
#   && make -C contrib install     # contrib error paths are Tier 2 scenarios
PGBIN=<install>/bin PGSRC=<postgres-src> \
CATALOG=/path/to/pg-log-catalog.jsonl \
LOG_LEVEL=debug5 reproducers/run.sh --direct
```

Postgres refuses to run as root, so the direct path must run as an unprivileged
user. The captured jsonlog can be large; it stays in the scratch `WORKDIR` and is
not committed — only `coverage-report.md` is.

### Per-scenario Tier 2 + Tier 3-4 captures

The committed `coverage-report.md` and `reproduced-sites.json` attribute every
newly-reproduced site to the scenario that fired it. That needs a *per-scenario*
capture, which two drivers produce (both write `<tier>__<scenario>.json` caps a
shared join step consumes):

```sh
# Tier 2 — one cap per crafted-SQL scenario (scenarios/15-43). Shares one
# cluster, preloads the baseline scenarios, isolates each scenario's jsonlog.
PGBIN=<install>/bin PGLIB=<install>/lib \
OUTDIR=/tmp/caps LOG_LEVEL=debug5 reproducers/sql-caps.sh

# Tier 3-4 — one cap per hostile-environment scenario. Stands up a fresh scratch
# cluster (or a primary/standby pair) per scenario.
PGBIN=<install>/bin PGLIB=<install>/lib \
CATALOG=/path/to/pg-log-catalog.jsonl \
BASELINE=/path/to/tier1-capture.json \
LOG_LEVEL=debug5 reproducers/env-run.sh

# join everything: baseline + all caps -> the committed artifacts.
python3 reproducers/env-coverage.py --catalog <catalog.jsonl> \
    --caps <dir-of-all-caps> --baseline <tier1-capture.json> \
    --out reproducers/coverage-report.md \
    --json-out reproducers/reproduced-sites.json
```

`BASELINE` is the Tier 1 capture jsonlog (`run.sh` over `scenarios/00`-`14`); the
report shows the Tier 2-4 delta over it. `ONLY="corruption replication"`
restricts an `env-run.sh` run to named scenarios. The disk-full scenario needs a
small full-able filesystem: run the driver as root (it mounts a tmpfs itself) or
hand it a pre-mounted one via `DISKFULL_DIR`.

The same scenarios ship as a parametrized image (`env/Dockerfile`, extends the
base image) for the container path; `SCENARIO=<name>` picks one.

## How coverage is computed

`coverage.py` loads the catalog and the captured jsonlog, then matches on
`(basename, line)` — Postgres trims `__FILE__` to a basename, so the catalog's
`postgres/src/backend/utils/adt/int.c` joins against the log's `int.c`. The
headline number is the count of **distinct catalog sites hit by an exact
`file:line` match**. A `±window` count is also reported as a diagnostic for the
few sites where the macro `__LINE__` lands a line or two off the recorded call
line; it is not the headline.

## Current numbers

From a HEAD build (commit `54cd6fc`) at `log_min_messages = debug5`:

- Baseline (Tier 1, `scenarios/00`-`14`): **245 of 14,806** sites by exact
  `file:line`.
- Tier 2 (`scenarios/15`-`43`, the broad crafted-SQL error corpus + contrib)
  adds **363 new distinct sites**.
- Tier 3-4 env variants add **110 new distinct sites** on top.
- **Combined: 718 of 14,806 (4.85%).**

Tier 2 example: the driver runs `SELECT 32768::int2`; the cluster logs
`int.c:942 "smallint out of range"`, joining to catalog site
`postgres/src/backend/utils/adt/int.c:942` [`ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE`].

Tier 4 example: the streaming-standby scenario replays WAL and logs
`xlogrecovery.c:1699 "redo starts at %X/%08X"` [LOG] and, on promotion,
`xlogrecovery.c:4451 "received promote request"` — recovery sites a lone cluster
never reaches. See `coverage-report.md` for the full per-tier breakdown.

## Reachability tiers

Two tiers are reachable from a single stock cluster:

- **Tier 1 — free (lifecycle).** Boot, checkpoint, autovacuum, connection and
  shutdown LOG sites. They fire just by starting and stopping the cluster;
  `00_setup.sql` adds maintenance commands (`VACUUM`, `ANALYZE`, `REINDEX`,
  `CLUSTER`, `CHECKPOINT`) to widen this.
- **Tier 2 — high-yield (user-triggerable ERRORs).** Crafted SQL that provokes
  clusters of call sites, exercised systematically across `scenarios/15`-`43`:
  every built-in type's input/range/cast/overflow errors; the DDL and catalog
  surface (`ALTER TABLE`, `CREATE`/`ALTER` for every object type, constraints,
  partitions); function/operator resolution and coercion; query semantics
  (aggregates, windows, CTEs, `MERGE`, `ON CONFLICT`); transaction/cursor/COPY/
  `EXPLAIN` state; the plpgsql runtime; the system/admin functions; and the
  installed `contrib` extensions' own input and validation paths. The type input
  functions in `utils/adt` alone are ~1,700 catalog sites, and `tablecmds.c`
  another ~490 — this is the largest reachable vein.

The env-variant tiers (driver `env-run.sh`, image `env/Dockerfile`) reach sites
no stock cluster can:

- **Tier 3 — configuration & auth.** A cluster reloaded onto broken
  `postgresql.conf` values, malformed `pg_hba.conf`/`pg_ident.conf`, rejecting
  auth (scram mismatch, no entry, required-SSL) — GUC validators, the HBA
  tokenizer, and the auth FATAL paths.
- **Tier 4 — corruption, replication, resource, crash.** A scribbled
  checksummed page; a streaming primary/standby pair with a slot and a
  promotion; logical publication/subscription (decoding, apply worker, table
  sync, snapshot builder); statement/lock/idle timeouts and connection-limit
  refusals; a disk-full write; and an un-clean shutdown that triggers crash
  recovery on restart.

Out of reach in a plain container here (and honestly reported as such):
out-of-memory (needs a cgroup cap), genuine `amcheck`/`pageinspect` corruption
*reports* (the modules are installed and their argument/validation errors fire,
but a real finding surfaces as a result row, not a log line), archiver failures,
and startup-time config fatals that print to stderr before the logging collector
starts. Growing the number further is mostly more scenarios against these tiers.
