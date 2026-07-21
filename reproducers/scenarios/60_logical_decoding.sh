#!/usr/bin/env bash
# 60 — logical decoding: test_decoding and pgoutput slots, peek/get changes,
# a streamed pg_recvlogical session, a large transaction spilled/streamed by a
# tiny logical_decoding_work_mem, plus the wal_level and wrong-slot-kind errors.
# This lights up decode.c / reorderbuffer.c / snapbuild.c / logical.c /
# logicalfuncs.c — including the snapshot-build DEBUG sites that only appear at a
# high log level while a logical slot is being created.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/../lib.sh"

repl_begin 60_logical_decoding

primary="$SCEN_DIR/primary"
replica_only="$SCEN_DIR/replica_only"

repl_primary_up "$primary" logical
pport="$PGPORT"; psock="$PGSOCK"

# --- two output plugins over the same change stream -------------------------
qpsql "$psock" "$pport" <<'SQL'
CREATE TABLE t (id int PRIMARY KEY, v text);
SELECT pg_create_logical_replication_slot('td', 'test_decoding');
SELECT pg_create_logical_replication_slot('po', 'pgoutput');
CREATE PUBLICATION p FOR ALL TABLES;
INSERT INTO t SELECT g, 'row'||g FROM generate_series(1, 200) g;
UPDATE t SET v = v || '!' WHERE id <= 20;
DELETE FROM t WHERE id > 190;
SQL

# Peek (non-consuming) then get (consuming) via test_decoding.
qpsql "$psock" "$pport" \
    -c "SELECT count(*) FROM pg_logical_slot_peek_changes('td', NULL, NULL);"
qpsql "$psock" "$pport" \
    -c "SELECT count(*) FROM pg_logical_slot_get_changes('td', NULL, NULL);"
# pgoutput is binary; drive it through its own decode path with the protocol args.
qpsql "$psock" "$pport" -c \
    "SELECT count(*) FROM pg_logical_slot_get_binary_changes('po', NULL, NULL,
        'proto_version', '4', 'publication_names', 'p');"

# --- stream a live logical session with pg_recvlogical (bounded) ------------
recv="${PGBIN:+$PGBIN/}pg_recvlogical"
qpsql "$psock" "$pport" -c "SELECT pg_create_logical_replication_slot('stream', 'test_decoding');"
timeout 6 "$recv" -h "$psock" -p "$pport" -U postgres -d postgres \
    -S stream --start -o skip-empty-xacts=1 -f /dev/null >/dev/null 2>&1 &
streamer=$!
sleep 1
qpsql "$psock" "$pport" -c "INSERT INTO t SELECT g, 'live'||g FROM generate_series(300, 400) g;"
sleep 2
wait "$streamer" 2>/dev/null || true

# --- large transaction: a tiny work_mem forces the reorder buffer to spill to
# disk and (with streaming enabled) stream in-progress — reorderbuffer.c serialize
# / stream sites. --------------------------------------------------------------
qpsql "$psock" "$pport" -c "ALTER SYSTEM SET logical_decoding_work_mem = '64kB';"
pg_ctl -D "$primary" reload >/dev/null 2>&1 || true
qpsql "$psock" "$pport" -c "SELECT pg_create_logical_replication_slot('big', 'test_decoding');"
qpsql "$psock" "$pport" <<'SQL'
BEGIN;
INSERT INTO t SELECT g, repeat('w', 200) FROM generate_series(10000, 60000) g;
UPDATE t SET v = v || 'x' WHERE id BETWEEN 10000 AND 30000;
COMMIT;
SQL
qpsql "$psock" "$pport" -c \
    "SELECT count(*) FROM pg_logical_slot_get_changes('big', NULL, NULL,
        'stream-changes', '1', 'include-xids', '0');"
qpsql "$psock" "$pport" -c "ALTER SYSTEM RESET logical_decoding_work_mem;"
pg_ctl -D "$primary" reload >/dev/null 2>&1 || true

# --- error surface ----------------------------------------------------------
qpsql "$psock" "$pport" <<'SQL'
SELECT pg_create_physical_replication_slot('phys');
SELECT * FROM pg_logical_slot_get_changes('phys', NULL, NULL);   -- physical slot, not logical
SELECT pg_create_logical_replication_slot('td', 'test_decoding'); -- already exists
SELECT pg_create_logical_replication_slot('badplugin', 'no_such_output_plugin'); -- no plugin
SQL

# wal_level too low for logical decoding, on a separate replica-level cluster.
repl_primary_up "$replica_only" replica
rport="$PGPORT"
qpsql "$PGSOCK" "$rport" \
    -c "SELECT pg_create_logical_replication_slot('nope', 'test_decoding');"  # needs wal_level=logical

repl_capture 60_logical_decoding_replica_only "$replica_only"
repl_capture 60_logical_decoding_primary "$primary"
