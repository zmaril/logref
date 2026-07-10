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
  `postgres/postgres` and does `configure && make && make install`; nothing is
  pinned to a released tag.
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
scenarios/*.sql     deliberately-wrong statements, grouped by theme
run.sh              boots the cluster, runs every scenario, joins, writes the report
coverage.py         the catalog join + report generator
coverage-report.md  the committed result
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
#   && ./configure --prefix=<install> && make && make install
PGBIN=<install>/bin PGSRC=<postgres-src> \
CATALOG=/path/to/pg-log-catalog.jsonl \
LOG_LEVEL=debug5 reproducers/run.sh --direct
```

Postgres refuses to run as root, so the direct path must run as an unprivileged
user. The captured jsonlog can be large; it stays in the scratch `WORKDIR` and is
not committed — only `coverage-report.md` is.

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

- **243 of 14,806 catalog sites reproduced** (1.64%) by exact `file:line`.
- By severity: 152 ERROR, 12 LOG, plus DEBUG1–5, WARNING, INFO and sites whose
  catalog level is a runtime expression.
- Top files hit include `tablecmds.c`, `float.c`, `int.c`, `numeric.c`,
  `xlog.c`/`xlogrecovery.c`, `jsonfuncs.c`, and the parser's `parse_*.c`.

Example: the driver runs `SELECT 32768::int2`; the cluster logs
`int.c:942 "smallint out of range"`, which joins to catalog site
`postgres/src/backend/utils/adt/int.c:942`
[`ERRCODE_NUMERIC_VALUE_OUT_OF_RANGE`]. See `coverage-report.md` for the full
breakdown and more samples.

## Reachability tiers

Scenarios target the two tiers reachable from a single stock cluster:

- **Tier 1 — free (lifecycle).** Boot, checkpoint, autovacuum, connection and
  shutdown LOG sites. They fire just by starting and stopping the cluster;
  `00_setup.sql` adds maintenance commands (`VACUUM`, `ANALYZE`, `REINDEX`,
  `CLUSTER`, `CHECKPOINT`) to widen this.
- **Tier 2 — high-yield (user-triggerable ERRORs).** Crafted SQL that provokes
  clusters of call sites: parser/syntax, type input, numeric range and math,
  constraint violations, missing catalog objects, duplicate objects, privileges,
  JSON/jsonpath, date/time, strings/regex, query semantics, arrays/rows, and
  transaction/session control. This is where most of the 243 come from — the type
  input functions in `utils/adt` alone are ~1,700 catalog sites.

Later tiers are **future env-variant images**, not part of this increment:

- **Tier 3 — configuration & GUC.** Bad `postgresql.conf`/`pg_hba.conf`, failed
  auth, resource-limit refusals — a cluster booted with hostile config.
- **Tier 4 — I/O, corruption, OOM, replication.** Disk errors, torn pages,
  out-of-memory, and primary/standby setups. These need fault injection or a
  multi-node topology and belong in dedicated images.

Growing the number is mostly a matter of adding scenarios and env-variant images
against these tiers.
