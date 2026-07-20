-- dblink / postgres_fdw connection+validation errors, plus multi-AM index setup
-- so pageinspect/amcheck/pgstattuple reach GIN/GiST/BRIN/hash/SP-GiST paths.
-- dblink
SELECT dblink_connect('myconn', 'host=127.0.0.1 port=1 dbname=nope connect_timeout=1');
SELECT dblink('host=127.0.0.1 port=1 connect_timeout=1', 'SELECT 1');
SELECT dblink_exec('nonexistent_conn', 'SELECT 1');
SELECT dblink_get_connections();
SELECT dblink_disconnect('nonexistent_conn');
SELECT dblink_error_message('nonexistent_conn');
SELECT * FROM dblink('nonexistent_conn', 'SELECT 1') AS t(a int);
SELECT dblink_open('nonexistent_conn', 'c', 'SELECT 1');
SELECT dblink_fetch('nonexistent_conn', 'c', 1);
SELECT dblink_build_sql_insert('repro.nope'::regclass, '{1}'::int2vector, 1, '{a}', '{b}');
-- postgres_fdw
CREATE SERVER pgfdw FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '127.0.0.1', port '1', dbname 'nope');
CREATE SERVER pgfdw2 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (nonsense_option 'x');
CREATE USER MAPPING FOR postgres SERVER pgfdw OPTIONS (user 'u', password 'p');
CREATE FOREIGN TABLE repro.ft (a int) SERVER pgfdw OPTIONS (table_name 'nope', nonsense 'x');
CREATE FOREIGN TABLE repro.ft2 (a int) SERVER pgfdw OPTIONS (table_name 'nope');
SELECT * FROM repro.ft2;
ALTER SERVER pgfdw OPTIONS (SET fetch_size 'notanumber');
-- index AM setup + inspect
CREATE TABLE repro.amt (id int, t text, arr int[], g point, its tsvector);
INSERT INTO repro.amt SELECT g, 'w'||g, ARRAY[g], point(g,g), to_tsvector('english','word'||g) FROM generate_series(1,500) g;
CREATE INDEX amt_gin ON repro.amt USING gin (arr);
CREATE INDEX amt_gist ON repro.amt USING gist (g);
CREATE INDEX amt_brin ON repro.amt USING brin (id);
CREATE INDEX amt_hash ON repro.amt USING hash (id);
CREATE INDEX amt_spgist ON repro.amt USING spgist (g);
CREATE INDEX amt_bloom ON repro.amt USING bloom (id, t) WITH (length=80, col1=2);
CREATE INDEX amt_btgin ON repro.amt USING gin (id) ;
SELECT gin_metapage_info(get_raw_page('amt_gin', 0));
SELECT gin_page_opaque_info(get_raw_page('amt_gin', 1));
SELECT gin_leafpage_items(get_raw_page('amt_gin', 999999));
SELECT gist_page_opaque_info(get_raw_page('amt_hash', 0));
SELECT gist_page_items(get_raw_page('amt_gist', 0), 'amt_gist');
SELECT gist_page_items_bytea(get_raw_page('amt_btgin', 0));
SELECT brin_page_type(get_raw_page('amt_brin', 0));
SELECT brin_metapage_info(get_raw_page('amt_gin', 0));
SELECT brin_revmap_data(get_raw_page('amt_gist', 0));
SELECT hash_metapage_info(get_raw_page('amt_gist', 0));
SELECT hash_page_stats(get_raw_page('amt_hash', 1), 'amt_hash');
SELECT hash_bitmap_info('amt_gist', 0);
SELECT spg_metapage(get_raw_page('amt_spgist', 0));
SELECT bt_index_check('amt_gin');
SELECT bt_multi_range_check('amt_brin', 1, 1);
SELECT pgstatginindex('amt_brin');
SELECT pgstathashindex('amt_gin');
SELECT pgstattuple_approx('repro.child_v');
SELECT pgstattuple_approx('amt_hash');
SELECT verify_heapam(relation => 'repro.child_v');
SELECT verify_heapam(relation => 'repro.parent', startblock => 999999);
SELECT verify_heapam(relation => 'amt_gin');
