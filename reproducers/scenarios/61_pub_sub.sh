#!/usr/bin/env bash
# 61 — publications & subscriptions: the CREATE PUBLICATION option matrix, a live
# subscription (apply + tablesync workers), an apply-time conflict, the ALTER
# SUBSCRIPTION surface (DISABLE/ENABLE/SET/REFRESH + disable_on_error), the
# replication-origin functions, replication-slot sync onto a standby, and the
# does-not-exist / could-not-connect errors. Exercises publicationcmds.c /
# subscriptioncmds.c / worker.c / tablesync.c / conflict.c / origin.c and the
# slotsync.c path — the widest logical-replication log surface in the tree.
set -uo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=/dev/null
source "$SCRIPT_DIR/../lib.sh"

repl_begin 61_pub_sub

pub="$SCEN_DIR/pub"
sub="$SCEN_DIR/sub"
pubstandby="$SCEN_DIR/pub_standby"

repl_primary_up "$pub" logical
pubport="$PGPORT"; pubsock="$PGSOCK"

# --- subscriber is its own logical cluster ----------------------------------
init_cluster "$sub"
repl_conf "$sub" \
    "wal_level=logical" \
    "max_logical_replication_workers=8" \
    "max_worker_processes=12" \
    "max_replication_slots=12" \
    "max_sync_workers_per_subscription=4"
repl_track "$sub"
start_cluster "$sub"
subport="$PGPORT"; subsock="$PGSOCK"
conn="host=127.0.0.1 port=$pubport user=postgres dbname=postgres"

# --- publication option matrix ----------------------------------------------
qpsql "$pubsock" "$pubport" <<'SQL'
CREATE SCHEMA s1;
CREATE TABLE public.docs (id int PRIMARY KEY, owner text, body text, secret text);
CREATE TABLE public.nums (id int PRIMARY KEY, n int);
CREATE TABLE s1.things (id int PRIMARY KEY, label text);
CREATE TABLE public.parent (id int PRIMARY KEY, region text) PARTITION BY LIST (region);
CREATE TABLE public.parent_e PARTITION OF public.parent FOR VALUES IN ('e');
CREATE TABLE public.parent_w PARTITION OF public.parent FOR VALUES IN ('w');

INSERT INTO public.docs SELECT g, 'u'||(g%4), 'body'||g, 'shh'||g FROM generate_series(1, 300) g;
INSERT INTO public.nums SELECT g, g*2 FROM generate_series(1, 300) g;
INSERT INTO s1.things SELECT g, 'l'||g FROM generate_series(1, 100) g;
INSERT INTO public.parent VALUES (1,'e'),(2,'w'),(3,'e');

CREATE PUBLICATION p_all FOR ALL TABLES;
CREATE PUBLICATION p_schema FOR TABLES IN SCHEMA s1;
CREATE PUBLICATION p_cols FOR TABLE public.docs (id, owner, body);        -- column list
CREATE PUBLICATION p_filter FOR TABLE public.nums WHERE (n > 100);        -- row filter
CREATE PUBLICATION p_ins WITH (publish = 'insert');                       -- insert-only
CREATE PUBLICATION p_root FOR TABLE public.parent
    WITH (publish_via_partition_root = true);
ALTER PUBLICATION p_ins ADD TABLE public.nums;
ALTER PUBLICATION p_cols SET (publish = 'insert, update');
SQL

# --- the live subscription: apply + tablesync workers -----------------------
qpsql "$subsock" "$subport" <<'SQL'
CREATE TABLE public.docs (id int PRIMARY KEY, owner text, body text);
CREATE TABLE public.nums (id int PRIMARY KEY, n int);
SQL
qpsql "$subsock" "$subport" -c \
    "CREATE SUBSCRIPTION sub_cols CONNECTION '$conn' PUBLICATION p_cols, p_filter
        WITH (streaming = on, disable_on_error = true);"
repl_wait_streaming "$pubport" 1 30 || log "  no walsender for the subscription yet"
sleep 3

# --- apply conflict: a row the incoming stream will also insert -------------
# HEAD reports the duplicate-key apply failure through conflict.c; with
# disable_on_error the worker then disables itself (subscriptioncmds.c).
qpsql "$subsock" "$subport" -c "INSERT INTO public.nums VALUES (250, -1);"
qpsql "$pubsock" "$pubport" -c "INSERT INTO public.nums VALUES (250, 500);"
sleep 3

# --- ALTER SUBSCRIPTION surface ---------------------------------------------
qpsql "$subsock" "$subport" <<'SQL'
ALTER SUBSCRIPTION sub_cols DISABLE;
ALTER SUBSCRIPTION sub_cols SET (disable_on_error = false, streaming = off);
ALTER SUBSCRIPTION sub_cols SET (origin = none);
ALTER SUBSCRIPTION sub_cols ENABLE;
ALTER SUBSCRIPTION sub_cols REFRESH PUBLICATION;
SQL
sleep 2

# --- replication origin functions + does-not-exist errors -------------------
qpsql "$subsock" "$subport" <<'SQL'
SELECT pg_replication_origin_create('demo_origin');
SELECT pg_replication_origin_session_setup('demo_origin');
SELECT pg_replication_origin_xact_setup('0/1', now());
SELECT pg_replication_origin_session_reset();
SELECT pg_replication_origin_advance('demo_origin', '0/10');
SELECT pg_replication_origin_progress('demo_origin', false);
SELECT pg_replication_origin_drop('demo_origin');
SELECT pg_replication_origin_drop('ghost_origin');       -- does not exist
SELECT pg_replication_origin_session_setup('ghost_origin'); -- does not exist
SQL

# --- slot sync onto a standby of the publisher ------------------------------
# A physical standby feeding back to the publisher can sync the subscription's
# logical slots for failover. Configure it, then drive the sync path (GUC +
# function); slotsync.c logs the sync/skip decisions. Tolerated end to end.
qpsql "$pubsock" "$pubport" -c "SELECT pg_create_physical_replication_slot('sb_slot');"
if repl_standby_up "$pub" "$pubport" "$pubstandby"; then
    sbport="$PGPORT"
    repl_conf "$pubstandby" \
        "hot_standby_feedback=on" \
        "primary_slot_name='sb_slot'" \
        "sync_replication_slots=on"
    repl_conf "$pub" "synchronized_standby_slots='sb_slot'"
    pg_ctl -D "$pub" reload >/dev/null 2>&1 || true
    pg_ctl -D "$pubstandby" restart -w >/dev/null 2>&1 || true
    repl_wait_standby_ready "$pubstandby" "$sbport" 20 || true
    qpsql "$(sock_of "$pubstandby")" "$sbport" -c "SELECT pg_sync_replication_slots();"
    sleep 2
    repl_capture 61_pub_sub_pub_standby "$pubstandby"
fi

# --- does-not-exist and could-not-connect errors ----------------------------
qpsql "$subsock" "$subport" <<SQL
DROP SUBSCRIPTION IF EXISTS ghost_sub;
ALTER SUBSCRIPTION ghost_sub DISABLE;                                     -- does not exist
CREATE SUBSCRIPTION dead CONNECTION 'host=127.0.0.1 port=1 user=postgres dbname=postgres'
    PUBLICATION p_all;                                                    -- could not connect
CREATE SUBSCRIPTION deferred CONNECTION 'host=127.0.0.1 port=1 dbname=postgres'
    PUBLICATION p_all WITH (connect = false, slot_name = NONE);           -- created, not connected
SQL
qpsql "$pubsock" "$pubport" -c "ALTER PUBLICATION ghost_pub ADD TABLE public.docs;"  # does not exist

# --- teardown of the live subscription (slot teardown logs) -----------------
qpsql "$subsock" "$subport" -c "DROP SUBSCRIPTION IF EXISTS sub_cols;"
sleep 1

repl_capture 61_pub_sub_subscriber "$sub"
repl_capture 61_pub_sub_publisher "$pub"
