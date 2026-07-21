#!/usr/bin/env bash
#
# LogRef reproducer — transaction/lock CONCURRENCY driver (needs 2 sessions).
#
# The .sql scenarios run against a single psql session and so can never provoke
# the contention paths: two transactions have to race for the same rows. This
# standalone driver stands up its own scratch cluster (wired for jsonlog
# provenance by lib.sh) and choreographs pairs of concurrent sessions to fire:
#
#   * deadlock detection ...... "deadlock detected"
#   * lock timeout ............ "canceling statement due to lock timeout"
#   * FOR UPDATE NOWAIT ....... "could not obtain lock on row in relation ..."
#   * serializable (SSI) ...... "could not serialize access due to read/write
#                               dependencies among transactions"
#   * concurrent update ....... "could not serialize access due to concurrent update"
#   * idle-in-transaction ..... "terminating connection due to idle-in-transaction timeout"
#
# Target source files: src/backend/storage/lmgr/lock.c, .../deadlock.c,
#   .../proc.c, .../predicate.c, src/backend/tcop/postgres.c (timeout cancels).
#
# It is deliberately standalone (does NOT touch env-run.sh / run.sh) so it can be
# run beside the sibling drivers without port/socket collisions. It reuses the
# shared lifecycle helpers from lib.sh (init_cluster/start_cluster/stop_cluster/
# qpsql/jsonlog_of) rather than re-implementing them. It does NOT run coverage
# tooling — it just leaves a jsonlog whose path it prints, for the harness to
# join against the catalog.
#
# Standalone use:  PGBIN=/path/to/pg/bin PGLIB=/path/to/pg/lib ./50_txn_concurrency.sh
# Postgres refuses to run as root; run as an unprivileged user.

set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$HERE/../lib.sh"
driver_env_setup                 # PGBIN/PGLIB on PATH, initdb check, OUTDIR/CAPS
# Port range distinct from run.sh (55999) and env-run.sh (55990+) so this driver
# can run alongside them.
export PGPORT_NEXT="${PGPORT_NEXT:-56200}"

DATADIR="$OUTDIR/txncc/pgdata"
init_cluster "$DATADIR"
# Fast, chatty contention: detect deadlocks quickly and log lock waits so the
# proc.c/deadlock.c LOG sites fire too.
{
    echo "deadlock_timeout = '150ms'"
    echo "log_lock_waits = on"
    echo "max_prepared_transactions = 0"
} >> "$DATADIR/postgresql.conf"
start_cluster "$DATADIR"
SOCK="$PGSOCK" PORT="$PGPORT"

# Seed one table per scenario so the races do not interfere with each other.
qpsql "$SOCK" "$PORT" <<'SQL'
CREATE TABLE dl (id int PRIMARY KEY, v int);
INSERT INTO dl VALUES (1, 0), (2, 0);
CREATE TABLE lt (id int PRIMARY KEY, v int);
INSERT INTO lt VALUES (1, 0);
CREATE TABLE nw (id int PRIMARY KEY, v int);
INSERT INTO nw VALUES (1, 0);
CREATE TABLE ssi (id int PRIMARY KEY, v int);
INSERT INTO ssi VALUES (1, 0), (2, 0);
CREATE TABLE cu (id int PRIMARY KEY, v int);
INSERT INTO cu VALUES (1, 0);
SQL

# --- deadlock: A locks row 1 then waits for row 2; B locks row 2 then row 1 ---
log "deadlock"
(
    qpsql "$SOCK" "$PORT" <<'SQL'
BEGIN;
UPDATE dl SET v = v + 1 WHERE id = 1;
SELECT pg_sleep(1);
UPDATE dl SET v = v + 1 WHERE id = 2;
COMMIT;
SQL
) &
dl_a=$!
sleep 0.3
qpsql "$SOCK" "$PORT" <<'SQL'
BEGIN;
UPDATE dl SET v = v + 1 WHERE id = 2;
SELECT pg_sleep(1);
UPDATE dl SET v = v + 1 WHERE id = 1;
COMMIT;
SQL
wait "$dl_a" 2>/dev/null || true

# --- lock timeout: holder takes ACCESS EXCLUSIVE; contender waits with a cap ---
log "lock_timeout"
(
    qpsql "$SOCK" "$PORT" <<'SQL'
BEGIN;
LOCK TABLE lt IN ACCESS EXCLUSIVE MODE;
SELECT pg_sleep(2);
COMMIT;
SQL
) &
lt_h=$!
sleep 0.5
qpsql "$SOCK" "$PORT" -c "SET lock_timeout = '100ms'; LOCK TABLE lt IN ACCESS EXCLUSIVE MODE;"
wait "$lt_h" 2>/dev/null || true

# --- NOWAIT: holder holds FOR UPDATE on a row; contender asks NOWAIT ---
log "nowait"
(
    qpsql "$SOCK" "$PORT" <<'SQL'
BEGIN;
SELECT * FROM nw WHERE id = 1 FOR UPDATE;
SELECT pg_sleep(2);
COMMIT;
SQL
) &
nw_h=$!
sleep 0.5
qpsql "$SOCK" "$PORT" -c "SELECT * FROM nw WHERE id = 1 FOR UPDATE NOWAIT;"
wait "$nw_h" 2>/dev/null || true

# --- serialization failure (SSI): read/write dependency cycle across two
#     SERIALIZABLE txns. Each reads the row the other will write. ---
log "ssi"
(
    qpsql "$SOCK" "$PORT" <<'SQL'
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT v FROM ssi WHERE id = 1;
SELECT pg_sleep(1);
UPDATE ssi SET v = v + 1 WHERE id = 2;
COMMIT;
SQL
) &
ssi_1=$!
(
    qpsql "$SOCK" "$PORT" <<'SQL'
BEGIN ISOLATION LEVEL SERIALIZABLE;
SELECT v FROM ssi WHERE id = 2;
SELECT pg_sleep(1);
UPDATE ssi SET v = v + 1 WHERE id = 1;
COMMIT;
SQL
) &
ssi_2=$!
wait "$ssi_1" 2>/dev/null || true
wait "$ssi_2" 2>/dev/null || true

# --- concurrent update: two REPEATABLE READ txns updating the same row. The one
#     that took its snapshot first blocks, then aborts when it wakes. ---
log "concurrent_update"
(
    qpsql "$SOCK" "$PORT" <<'SQL'
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT v FROM cu WHERE id = 1;
SELECT pg_sleep(1.5);
UPDATE cu SET v = v + 1 WHERE id = 1;
COMMIT;
SQL
) &
cu_1=$!
sleep 0.3
qpsql "$SOCK" "$PORT" <<'SQL'
BEGIN ISOLATION LEVEL REPEATABLE READ;
UPDATE cu SET v = v + 100 WHERE id = 1;
COMMIT;
SQL
wait "$cu_1" 2>/dev/null || true

# --- idle-in-transaction timeout: a session that goes idle mid-transaction.
#     qpsql feeds the heredoc to psql's stdin, so psql's \! shell escape gives a
#     real CLIENT-side idle window (pg_sleep would keep the backend busy, not
#     idle). After the timeout the backend terminates the connection. ---
log "idle_in_transaction"
qpsql "$SOCK" "$PORT" <<'SQL'
SET idle_in_transaction_session_timeout = '300ms';
BEGIN;
SELECT 1;
\! sleep 1
SELECT 2;
SQL

stop_cluster "$DATADIR"
JSONLOG="$(jsonlog_of "$DATADIR")"
log "done. scratch: $OUTDIR"
echo "$JSONLOG"
