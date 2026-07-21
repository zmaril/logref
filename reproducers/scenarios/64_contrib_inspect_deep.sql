-- Tier 2 (deep) — inspection/stats modules beyond 42/43: amcheck DEBUG tree
-- traversal on valid indexes (heapallindexed / parent-check / rootdescend),
-- pageinspect wrong-page-type and privilege guards, pg_walinspect LSN-range
-- validation, and pgstattuple index-type errors. A dedicated unprivileged role
-- is created here because the shared lowpriv role is dropped by scenario 26.
CREATE ROLE repro_ins_ro;
CREATE TABLE repro.big (id int PRIMARY KEY, v text);
INSERT INTO repro.big SELECT g, 'w' || g FROM generate_series(1, 6000) g;

-- amcheck: a multi-level index walked with the heavy options fires the DEBUG
-- "verifying ..." sites (verify_nbtree.c) a single-page index never reaches.
-- Measured at debug5.
SELECT bt_index_check('repro.big_pkey', heapallindexed => true);
SELECT bt_index_parent_check('repro.big_pkey', heapallindexed => true, rootdescend => true);
SELECT bt_index_parent_check('repro.big_pkey', checkunique => true);
SELECT gin_index_check('amt_gin');
-- amcheck target-type guards (verify_common.c): wrong-AM verification targets.
SELECT gin_index_check('repro.big_pkey');
SELECT bt_index_parent_check('amt_gin');

-- pageinspect: valid raw page fed to the wrong page-type reader, an out-of-range
-- block, and a t_bits argument that should be NULL (rawpage.c / brinfuncs.c).
SELECT brin_metapage_info(get_raw_page('repro.big_pkey', 0));
SELECT brin_page_items(get_raw_page('amt_gin', 0), 'amt_gin');
SELECT brin_revmap_data(get_raw_page('repro.big_pkey', 0));
SELECT get_raw_page('repro.parent', -1);
SELECT tuple_data_split('repro.parent'::regclass, '\x00'::bytea, 0, 0, '\xff'::bytea);

-- pg_walinspect: LSN-range validation (pg_walinspect.c). Run as superuser; the
-- errors fire before any read.
SELECT pg_get_wal_record_info('FFFFFFFF/FFFFFFFF');
SELECT * FROM pg_get_wal_records_info('0/2000000', '0/1000000');
SELECT * FROM pg_get_wal_stats('FFFFFFFF/FFFF0000', 'FFFFFFFF/FFFFFFFF', true);
SELECT * FROM pg_get_wal_block_info('0/2000000', '0/1000000');

-- pgstattuple: wrong index AM for the specialized readers (pgstatindex.c).
SELECT pgstatginindex('repro.big_pkey');
SELECT pgstathashindex('amt_gin');
SELECT pgstatindex('amt_gin');

-- pageinspect privilege guards: no REVOKE on these, so a non-superuser reaches
-- the internal superuser() ereport rather than an executor ACL error.
SET ROLE repro_ins_ro;
SELECT get_raw_page('repro.parent', 0);
SELECT bt_metap('repro.big_pkey');
SELECT bt_page_stats('repro.big_pkey', 1);
SELECT bt_page_items('repro.big_pkey', 1);
SELECT heap_page_items(get_raw_page('repro.parent', 0));
SELECT brin_metapage_info(get_raw_page('amt_brin', 0));
SELECT page_header(get_raw_page('repro.parent', 0));
RESET ROLE;
