-- Tier 2 (deep) — postgres_fdw option validators, dblink driven over a live
-- loopback connection to this very cluster (so cursor/remote-error paths fire
-- for real), and pgcrypto salt/cipher/PGP error paths.

-- postgres_fdw: numeric and string option validators (option.c).
CREATE SERVER repro_fp1 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (fdw_startup_cost 'abc');
CREATE SERVER repro_fp2 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (fdw_startup_cost '-1');
CREATE SERVER repro_fp3 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (fetch_size 'abc');
CREATE SERVER repro_fp4 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (fetch_size '0');
CREATE SERVER repro_fp5 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (analyze_sampling 'bogus');
CREATE SERVER repro_fp6 FOREIGN DATA WRAPPER postgres_fdw OPTIONS (extensions 'no_such_ext_xyz');
-- password_required / sslcert are superuser-only on a user mapping. A dedicated
-- unprivileged role is used (the shared lowpriv role is dropped by scenario 26).
CREATE ROLE repro_fdw_ro;
CREATE SERVER repro_fp_ok FOREIGN DATA WRAPPER postgres_fdw OPTIONS (host '127.0.0.1', port '1', dbname 'nope');
GRANT USAGE ON FOREIGN SERVER repro_fp_ok TO repro_fdw_ro;
SET ROLE repro_fdw_ro;
CREATE USER MAPPING FOR repro_fdw_ro SERVER repro_fp_ok OPTIONS (password_required 'false');
CREATE USER MAPPING FOR repro_fdw_ro SERVER repro_fp_ok OPTIONS (sslcert 'x');
RESET ROLE;

-- dblink: connect back to this cluster over its own socket, then drive the
-- cursor lifecycle and remote-error paths (dblink.c) that need a real session.
SELECT dblink_connect('selfc',
    'host=' || split_part(current_setting('unix_socket_directories'), ',', 1) ||
    ' port=' || current_setting('port') || ' dbname=postgres user=postgres');
SELECT dblink_open('selfc', 'c1', 'SELECT g FROM generate_series(1, 5) g');
SELECT * FROM dblink_fetch('selfc', 'c1', 2) AS t(g int);
SELECT * FROM dblink_fetch('selfc', 'no_such_cursor', 1) AS t(g int);
SELECT dblink_close('selfc', 'c1');
SELECT * FROM dblink_fetch('selfc', 'c1', 1) AS t(g int);
SELECT dblink_exec('selfc', 'SELECT * FROM no_such_table_xyz');
SELECT * FROM dblink('selfc', 'SELECT * FROM no_such_table_xyz') AS t(g int);
SELECT dblink_disconnect('selfc');
-- dblink SQL builders: primary-key attribute-count mismatches.
SELECT dblink_build_sql_insert('repro.parent'::regclass, '1'::int2vector, 2, '{a}', '{b}');
SELECT dblink_build_sql_update('repro.parent'::regclass, '1'::int2vector, 2, '{a}', '{b}');
SELECT dblink_build_sql_delete('repro.parent'::regclass, '1'::int2vector, 2, '{a}');

-- pgcrypto: malformed salts (crypt-blowfish/des/gensalt/sha) and cipher errors.
SELECT crypt('pw', '$2a$04$short');
SELECT crypt('pw', '$5$rounds=0$abcdefgh$');
SELECT crypt('pw', '_z');
SELECT crypt('pw', '$6$rounds=1$');
SELECT gen_salt('des', 99);
SELECT gen_salt('xdes', 0);
SELECT gen_salt('bf', 32);
SELECT encrypt('data-not-block'::bytea, 'k'::bytea, 'aes-cbc/pad:none');
SELECT decrypt('\x1234'::bytea, 'key0123456789012'::bytea, 'aes');
SELECT encrypt_iv('x'::bytea, 'k'::bytea, 'shortiv'::bytea, 'aes');
SELECT decrypt_iv('\x00'::bytea, 'k'::bytea, 'iv'::bytea, 'aes');
SELECT encrypt('x'::bytea, 'k'::bytea, 'aes-foobar');
SELECT pgp_sym_encrypt('data', 'key', 'compress-algo=99');
SELECT pgp_sym_encrypt('data', 'key', 'cipher-algo=bogus');
