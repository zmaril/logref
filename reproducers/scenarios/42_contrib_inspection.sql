-- pageinspect, pgstattuple, amcheck, pg_visibility, pg_surgery, pg_walinspect,
-- pgcrypto, tablefunc, pg_prewarm, pgrowlocks — API/validation error paths.
-- pageinspect
SELECT get_raw_page('repro.parent', 999999);
SELECT get_raw_page('repro.nope', 0);
SELECT get_raw_page('repro.child_v', 0);
SELECT get_raw_page('repro.parent', 'nonsense', 0);
SELECT page_header('\x00'::bytea);
SELECT heap_page_items('\xdeadbeef'::bytea);
SELECT bt_page_stats('child_amount_idx', 0);
SELECT bt_page_items('repro.parent', 0);
SELECT bt_metap('repro.parent');
SELECT tuple_data_split('repro.parent'::regclass, '\x00'::bytea, 0, 0, NULL);
SELECT fsm_page_contents('\x00'::bytea);
SELECT gin_metapage_info('\x00'::bytea);
SELECT brin_page_type('\x00'::bytea);
SELECT hash_metapage_info('\x00'::bytea);
SELECT page_checksum('\x00'::bytea, 0);
-- pgstattuple
SELECT pgstattuple('repro.nope');
SELECT pgstattuple('repro.child_v');
SELECT pgstatindex('repro.parent');
SELECT pgstatginindex('child_amount_idx');
SELECT pg_relpages('repro.nope');
SELECT pgstathashindex('child_amount_idx');
-- amcheck
SELECT bt_index_check('repro.parent');
SELECT bt_index_check('child_amount_idx'::regclass);
SELECT bt_index_parent_check('repro.child_v');
SELECT bt_index_check(999999999);
SELECT gin_index_check('child_amount_idx');
-- pg_visibility
SELECT pg_visibility('repro.child_v');
SELECT pg_visibility('repro.parent', 999999);
SELECT pg_visibility_map_summary('repro.nope');
SELECT pg_check_frozen('repro.child_v');
SELECT pg_truncate_visibility_map('repro.child_v');
-- pg_surgery
SELECT heap_force_kill('repro.child_v', ARRAY['(0,1)']::tid[]);
SELECT heap_force_freeze('repro.parent', ARRAY['(999999,1)']::tid[]);
SELECT heap_force_kill('repro.parent', ARRAY[NULL]::tid[]);
-- pg_walinspect
SELECT * FROM pg_get_wal_record_info('0/0');
SELECT * FROM pg_get_wal_records_info('FFFFFFFF/FFFFFFFF', '0/0');
SELECT * FROM pg_get_wal_stats('0/0', '0/0', true);
-- pgrowlocks
SELECT * FROM pgrowlocks('repro.nope');
SELECT * FROM pgrowlocks('repro.child_v');
-- pg_prewarm
SELECT pg_prewarm('repro.nope');
SELECT pg_prewarm('repro.parent', 'nonsense');
SELECT pg_prewarm('repro.child_v', 'buffer');
SELECT pg_prewarm('repro.parent', 'buffer', 'nonsense');
-- pgcrypto
SELECT digest('x', 'nonexistent_algo');
SELECT hmac('x', 'k', 'nonexistent_algo');
SELECT crypt('x', 'badsalt');
SELECT gen_salt('nonsense');
SELECT gen_salt('bf', 99);
SELECT encrypt('x'::bytea, 'k'::bytea, 'nonexistent-cipher');
SELECT decrypt('\x00'::bytea, 'k'::bytea, 'aes');
SELECT pgp_sym_decrypt('\x00'::bytea, 'key');
SELECT pgp_sym_encrypt('x', 'k', 'nonsense-option=1');
SELECT encrypt_iv('x'::bytea, 'k'::bytea, 'iv'::bytea, 'aes');
-- tablefunc
SELECT * FROM normal_rand(-1, 0, 1);
SELECT * FROM crosstab('SELECT 1') AS ct(a int, b int);
SELECT * FROM connectby('repro.parent', 'id', 'id', '1', 0, '~') AS t(a int, b int, c int);
