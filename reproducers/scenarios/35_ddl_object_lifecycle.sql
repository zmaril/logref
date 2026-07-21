-- Object lifecycle: CREATE/ALTER/DROP, dependency, ownership, comment, namespace
-- -> src/backend/commands/tablecmds.c, catalog/dependency.c, catalog/namespace.c,
--    catalog/pg_depend.c, catalog/objectaddress.c
--
-- Targets distinct call sites NOT reached by 21/25/27/28. Objects are created
-- inline under schema s35 with unique names so re-runs don't collide.

CREATE SCHEMA s35;
CREATE SCHEMA s35b;
CREATE TABLE s35.base (id int PRIMARY KEY, label text NOT NULL);
CREATE TABLE s35b.base (id int);
INSERT INTO s35.base VALUES (1, 'one'), (2, 'two');
CREATE VIEW s35.base_v AS SELECT id FROM s35.base;
CREATE TABLE s35.owner_seq (id serial PRIMARY KEY);   -- owns s35.owner_seq_id_seq
CREATE TYPE s35.comp AS (a int, b text);
CREATE TABLE s35.usescomp (c s35.comp);
CREATE TYPE s35.rowt AS (a int, b int);
CREATE TABLE s35.typedtab OF s35.rowt;

-- Dependency: DROP without CASCADE while dependents exist (dependency.c 910/1216)
DROP TABLE s35.base;                     -- view s35.base_v depends on it
DROP TYPE s35.comp;                      -- column s35.usescomp.c depends on it
DROP SCHEMA s35b;                        -- not empty
DROP SEQUENCE s35.owner_seq_id_seq;      -- internal dependency: owned by a column

-- Dependency: pinned/system objects (dependency.c 553)
DROP TYPE pg_catalog.int4;
DROP FUNCTION pg_catalog.now();
DROP OPERATOR pg_catalog.+(integer, integer);
DROP CAST (integer AS bigint);

-- pg_depend: extension membership + DEPENDS ON EXTENSION on a missing extension
ALTER TABLE s35.base DEPENDS ON EXTENSION nosuchext;
ALTER INDEX s35.base_pkey DEPENDS ON EXTENSION nosuchext;

-- namespace.c: search-path / cross-db / qualified-name resolution
SET search_path TO '';
CREATE TABLE unqualified_t (a int);      -- no schema has been selected to create in
RESET search_path;
CREATE TABLE nosuchdb.public.t (a int);  -- cross-database references are not implemented
SELECT * FROM a.b.c.d;                    -- improper qualified name (too many dotted names)
CREATE TEMP TABLE s35.tt (a int);        -- temporary tables cannot specify a schema name

-- tablecmds.c: typed-table restrictions (7341 / 9398 / 3881)
ALTER TABLE s35.typedtab ADD COLUMN q int;
ALTER TABLE s35.typedtab DROP COLUMN a;
ALTER TABLE s35.typedtab RENAME COLUMN a TO z;

-- tablecmds.c: system-column rename, owned-sequence move/owner (4040 / 19686 / 16850)
ALTER TABLE s35.base RENAME COLUMN xmin TO x;
ALTER SEQUENCE s35.owner_seq_id_seq SET SCHEMA public;
ALTER SEQUENCE s35.owner_seq_id_seq OWNER TO lowpriv;

-- tablecmds.c: SET SCHEMA into a schema that already has a like-named relation
CREATE SCHEMA s35c;
CREATE TABLE s35c.dup (a int);
CREATE TABLE s35.dup (a int);
ALTER TABLE s35.dup SET SCHEMA s35c;     -- relation "dup" already exists in schema s35c

-- tablecmds.c: partitioned-index drop paths (1618 / 1622 / 1730)
CREATE TABLE s35.pidx (a int) PARTITION BY RANGE (a);
CREATE TABLE s35.pidx1 PARTITION OF s35.pidx FOR VALUES FROM (1) TO (10);
CREATE INDEX pidx_idx ON s35.pidx (a);
DROP INDEX CONCURRENTLY s35.pidx_idx, s35.pidx1_a_idx;   -- multiple objects
DROP INDEX CONCURRENTLY s35.pidx_idx CASCADE;            -- CASCADE unsupported
DROP INDEX CONCURRENTLY s35.pidx_idx;                    -- partitioned index
DROP INDEX s35.pidx1_a_idx;                              -- child of a partitioned index

-- tablecmds.c: TRUNCATE restrictions (2018)
TRUNCATE ONLY s35.pidx;

-- tablecmds.c: tablespace placement at CREATE (947 / 978)
CREATE TABLE s35.pt_ts (a int) PARTITION BY RANGE (a) TABLESPACE pg_default;
CREATE TABLE s35.g (a int) TABLESPACE pg_global;

-- tablecmds.c: WITH CHECK OPTION on a non-updatable view (17455)
CREATE VIEW s35.nonupd_v WITH (check_option = cascaded) AS
    SELECT count(*) AS n FROM s35.base;

-- objectaddress.c: COMMENT with wrong object subtype ("is not a ...")
COMMENT ON SEQUENCE s35.base IS 'x';     -- base is a table
COMMENT ON VIEW s35.base IS 'x';
COMMENT ON INDEX s35.base IS 'x';
COMMENT ON MATERIALIZED VIEW s35.base_v IS 'x';
COMMENT ON COLUMN s35.base_v.nosuchcol IS 'x';

-- per-type "already exists" beyond the relation/type variants in 21/28
CREATE PUBLICATION s35_pub;
CREATE PUBLICATION s35_pub;
CREATE MATERIALIZED VIEW s35.mv AS SELECT 1 AS a;
CREATE MATERIALIZED VIEW s35.mv AS SELECT 1 AS a;
CREATE FOREIGN DATA WRAPPER s35_fdw;
CREATE FOREIGN DATA WRAPPER s35_fdw;
CREATE SERVER s35_srv FOREIGN DATA WRAPPER s35_fdw;
CREATE SERVER s35_srv FOREIGN DATA WRAPPER s35_fdw;
CREATE EXTENSION plpgsql;                -- already installed in template

-- DROP wrong-kind / missing beyond 21 (objectaddress + per-command "is not a")
DROP MATERIALIZED VIEW s35.base;         -- base is a table
DROP VIEW s35.base;                      -- base is a table, not a view
DROP SEQUENCE s35.base;                  -- not a sequence
