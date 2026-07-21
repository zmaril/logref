#!/usr/bin/env bash
# 59 — replication slots: physical and logical creation/drop/advance, the
# error surface (already-exists, does-not-exist, wrong-type, wal_level too low,
# slot-is-active), size-bounded invalidation via max_slot_wal_keep_size, and a
# standby-side recovery conflict. The reporting lives in slot.c / slotfuncs.c /
# logical.c and the standby conflict path in standby.c — reachable only with a
# real slot and, for the last one, a real primary/standby pair.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/../lib.sh"

repl_begin 59_repl_slots

primary="$SCEN_DIR/primary"
standby="$SCEN_DIR/standby"
lowlevel="$SCEN_DIR/replica_only"

# --- a logical-level primary so both slot kinds are creatable ---------------
repl_primary_up "$primary" logical
pport="$PGPORT"; psock="$PGSOCK"

# Create, advance and drop across both slot kinds, then the error surface.
qpsql "$psock" "$pport" <<'SQL'
SELECT pg_create_physical_replication_slot('phys_a');
SELECT pg_create_physical_replication_slot('phys_b', true);
SELECT pg_create_logical_replication_slot('logic_a', 'test_decoding');
SELECT pg_create_logical_replication_slot('logic_b', 'pgoutput');
-- advance the reserved physical slot up to the current insert LSN
SELECT pg_replication_slot_advance('phys_b', pg_current_wal_lsn());
SELECT pg_drop_replication_slot('phys_a');
-- error surface:
SELECT pg_create_physical_replication_slot('phys_b');          -- already exists
SELECT pg_drop_replication_slot('nope');                       -- does not exist
SELECT * FROM pg_logical_slot_get_changes('phys_b', NULL, NULL);  -- not a logical slot
SELECT * FROM pg_replication_slot_advance('logic_a', '0/0');   -- cannot move backwards
SQL

# --- already-active error: hold a logical slot open with pg_recvlogical, then
# try to read it from a second session. Bounded by `timeout`, so the holder
# always releases and the driver never blocks. ------------------------------
recv="${PGBIN:+$PGBIN/}pg_recvlogical"
timeout 6 "$recv" -h "$psock" -p "$pport" -U postgres -d postgres \
    -S logic_a --start -o skip-empty-xacts=1 -f /dev/null >/dev/null 2>&1 &
holder=$!
sleep 2
qpsql "$psock" "$pport" \
    -c "SELECT * FROM pg_logical_slot_get_changes('logic_a', NULL, NULL);"  # active for PID
wait "$holder" 2>/dev/null || true

# --- size-bounded invalidation: a tiny max_slot_wal_keep_size, an unconsumed
# physical slot, then enough WAL + checkpoints to blow past it — slot.c logs
# "invalidating obsolete replication slot". ---------------------------------
qpsql "$psock" "$pport" -c "ALTER SYSTEM SET max_slot_wal_keep_size = '1MB';"
pg_ctl -D "$primary" reload >/dev/null 2>&1 || true
qpsql "$psock" "$pport" -c "SELECT pg_create_physical_replication_slot('to_invalidate');"
qpsql "$psock" "$pport" <<'SQL'
CREATE TABLE churn (id int, pad text);
INSERT INTO churn SELECT g, repeat('z', 512) FROM generate_series(1, 40000) g;
SELECT pg_switch_wal();
CHECKPOINT;
INSERT INTO churn SELECT g, repeat('z', 512) FROM generate_series(1, 40000) g;
SELECT pg_switch_wal();
CHECKPOINT;
SELECT slot_name, wal_status FROM pg_replication_slots WHERE slot_name='to_invalidate';
SQL
qpsql "$psock" "$pport" -c "ALTER SYSTEM RESET max_slot_wal_keep_size;"
pg_ctl -D "$primary" reload >/dev/null 2>&1 || true

# --- recovery conflict on a standby -----------------------------------------
# A standby with zero grace for conflicting WAL: a read holds a snapshot while
# the primary VACUUMs away rows the reader still needs, so the startup process
# cancels the query — standby.c logs "canceling statement due to conflict with
# recovery". The reader is short and the wait is bounded.
qpsql "$psock" "$pport" <<'SQL'
CREATE TABLE hot (id int PRIMARY KEY, v int);
INSERT INTO hot SELECT g, g FROM generate_series(1, 5000) g;
SQL
if repl_standby_up "$primary" "$pport" "$standby"; then
    sport="$PGPORT"; ssock="$PGSOCK"
    repl_conf "$standby" "max_standby_streaming_delay=0" "hot_standby_feedback=off"
    pg_ctl -D "$standby" restart -w >/dev/null 2>&1 || true
    repl_wait_standby_ready "$standby" "$sport" 20 || true
    # Long-ish read on the standby in the background...
    ( qpsql "$ssock" "$sport" -c \
        "BEGIN ISOLATION LEVEL REPEATABLE READ; SELECT count(*) FROM hot; SELECT pg_sleep(5); COMMIT;" ) &
    reader=$!
    sleep 1
    # ...while the primary removes the tuples the reader's snapshot pins.
    qpsql "$psock" "$pport" -c "DELETE FROM hot WHERE id % 2 = 0; VACUUM (FREEZE) hot;"
    wait "$reader" 2>/dev/null || true
    repl_capture 59_repl_slots_standby "$standby"
fi

# --- wal_level too low: a replica-level cluster cannot make a logical slot ---
repl_primary_up "$lowlevel" replica
lport="$PGPORT"
qpsql "$PGSOCK" "$lport" \
    -c "SELECT pg_create_logical_replication_slot('nope', 'test_decoding');"  # needs wal_level>=logical

repl_capture 59_repl_slots_lowlevel "$lowlevel"
repl_capture 59_repl_slots_primary "$primary"
