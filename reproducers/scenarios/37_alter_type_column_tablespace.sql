-- ALTER TYPE / ALTER COLUMN rules, domains, collation and tablespace
-- -> src/backend/commands/typecmds.c, commands/tablecmds.c, catalog/pg_enum.c,
--    commands/collationcmds.c, commands/tablespace.c, parser/parse_type.c
--
-- Distinct sites beyond 27/28. Objects created inline under schema s37.

CREATE SCHEMA s37;
CREATE TABLE s37.dep (a int, b int, c int, d int);
INSERT INTO s37.dep VALUES (1,1,1,1), (2,2,2,2);

-- ALTER COLUMN TYPE against a column another object depends on (tablecmds 15681/15751)
CREATE VIEW s37.dep_v AS SELECT a FROM s37.dep;
ALTER TABLE s37.dep ALTER COLUMN a TYPE bigint;      -- used by a view or rule
CREATE TABLE s37.gdep (a int, b int GENERATED ALWAYS AS (a * 2) STORED);
ALTER TABLE s37.gdep ALTER COLUMN a TYPE bigint;     -- used by a generated column
ALTER TABLE s37.gdep ALTER COLUMN b TYPE bigint USING b::bigint;  -- USING on generated col

-- ALTER COLUMN TYPE: system / inherited / typed-table columns (tablecmds 14954/14976/14936)
ALTER TABLE s37.dep ALTER COLUMN xmin TYPE text;
CREATE TABLE s37.ip (a int);
CREATE TABLE s37.ic (a int) INHERITS (s37.ip);
ALTER TABLE s37.ic ALTER COLUMN a TYPE bigint;
CREATE TYPE s37.rt AS (a int);
CREATE TABLE s37.typed OF s37.rt;
ALTER TABLE s37.typed ALTER COLUMN a TYPE bigint;

-- DROP COLUMN a dependent view relies on, RESTRICT (dependency.c)
ALTER TABLE s37.dep DROP COLUMN a RESTRICT;

-- ALTER TYPE on a table's row type instead of ALTER TABLE (typecmds 3824)
ALTER TYPE s37.dep RENAME ATTRIBUTE b TO bb;

-- Enum manipulation (pg_enum.c / typecmds 1363)
CREATE TYPE s37.mood AS ENUM ('sad', 'ok', 'happy');
ALTER TYPE s37.mood ADD VALUE 'happy';               -- label already exists
ALTER TYPE s37.mood ADD VALUE 'new' BEFORE 'nope';   -- neighbor label not found
ALTER TYPE s37.mood RENAME VALUE 'nope' TO 'x';      -- source label not found
CREATE TYPE s37.comp AS (a int, b text);
ALTER TYPE s37.comp RENAME VALUE 'a' TO 'b';         -- comp is not an enum

-- Range type definition errors (typecmds 1521 / 1540)
CREATE TYPE s37.badrng AS RANGE (subtype = anyelement);
CREATE TYPE s37.collrng AS RANGE (subtype = int, collation = "C");

-- Domain constraints impossible on domains + not-a-domain (typecmds 998/1005/1019/3534)
CREATE TABLE s37.pkt (id int PRIMARY KEY);
CREATE DOMAIN s37.d_uniq AS int UNIQUE;
CREATE DOMAIN s37.d_pk AS int PRIMARY KEY;
CREATE DOMAIN s37.d_fk AS int REFERENCES s37.pkt (id);
CREATE DOMAIN s37.d_null AS int NOT NULL NULL;
ALTER DOMAIN s37.mood SET NOT NULL;                  -- mood is a type, not a domain

-- Domain ADD CONSTRAINT / SET NOT NULL over violating data (typecmds 3214)
CREATE DOMAIN s37.posint AS int;
CREATE TABLE s37.usedom (v s37.posint);
INSERT INTO s37.usedom VALUES (-1), (5), (NULL);
ALTER DOMAIN s37.posint ADD CONSTRAINT gt0 CHECK (VALUE > 0);
ALTER DOMAIN s37.posint SET NOT NULL;

-- Collation errors (collationcmds.c 128 / 194 / 230 / 317 / 322)
CREATE COLLATION s37.c1 (LOCALE = 'C');
CREATE COLLATION s37.c1 (LOCALE = 'C');              -- already exists
CREATE COLLATION s37.c3 (PROVIDER = nonesuch, LOCALE = 'C');
CREATE COLLATION s37.c4 (LOCALE = 'C', LC_CTYPE = 'C');
CREATE COLLATION s37.c5 (LOCALE = 'C', DETERMINISTIC = false);
CREATE COLLATION s37.c6 (LOCALE = 'C', RULES = '&a < b');

-- COLLATE applied to a non-collatable type (parse_type.c 568 / parse_expr.c 2837)
CREATE TABLE s37.ct (a int COLLATE "C");
SELECT 1 COLLATE "C";
CREATE TABLE s37.cti (a int[] COLLATE "C");

-- Encoding conversion errors
SELECT convert('abc'::bytea, 'UTF8', 'NOSUCH_ENC');
SELECT convert_to('abc', 'NOSUCH_ENC');

-- Tablespace resolution (tablespace.c 431 via default_tablespace, tablecmds 17720)
SET default_tablespace = 'nosuch_ts';
CREATE TABLE s37.ts_t (a int);
RESET default_tablespace;
ALTER TABLE s37.dep SET TABLESPACE pg_global;        -- cannot move in/out of pg_global
DROP TABLESPACE nosuch_ts;                           -- does not exist
CREATE TABLESPACE s37_ts LOCATION 'relative/path';   -- must be an absolute path
CREATE TABLESPACE s37_ts2 LOCATION '/no/such/dir/logref_xyz';  -- create/stat failure
