-- DDL: duplicate/missing for many object types, illegal ALTER, dependencies.
CREATE SCHEMA repro;               -- already exists
CREATE SCHEMA IF NOT EXISTS repro; -- ok
CREATE TABLE repro.parent (x int); -- already exists
CREATE TABLE nosuchschema.t (x int);
CREATE TABLE repro.t_dup (a int, a int);
CREATE TABLE repro.t_noc ();
ALTER TABLE repro.nope ADD COLUMN c int;
ALTER TABLE repro.parent ADD COLUMN id int;      -- dup column
ALTER TABLE repro.parent DROP COLUMN nope;
ALTER TABLE repro.parent ALTER COLUMN id TYPE inet USING id;
ALTER TABLE repro.parent ALTER COLUMN label TYPE int USING label::int;
ALTER TABLE repro.parent RENAME COLUMN nope TO x;
ALTER TABLE repro.parent ADD CONSTRAINT pk PRIMARY KEY (label);
ALTER TABLE repro.child ADD CONSTRAINT fk FOREIGN KEY (parent_id) REFERENCES repro.nope(id);
ALTER TABLE repro.parent SET SCHEMA nosuchschema;
DROP TABLE repro.nope;
DROP TABLE repro.parent;          -- has dependents (child FK, view)
DROP VIEW repro.nope;
DROP INDEX repro.nope;
DROP SEQUENCE repro.nope;
DROP SCHEMA nosuchschema;
DROP SCHEMA repro;                -- not empty
CREATE INDEX ON repro.child (nosuchcol);
CREATE INDEX dup_idx ON repro.child (amount);
CREATE INDEX dup_idx ON repro.child (id);
CREATE UNIQUE INDEX ON repro.child (amount);   -- dup values
CREATE VIEW repro.child_v AS SELECT 1;         -- already exists
CREATE VIEW repro.badview AS SELECT * FROM repro.nope;
CREATE SEQUENCE repro.s START 5 MINVALUE 10;
CREATE SEQUENCE repro.s2 INCREMENT 0;
CREATE SEQUENCE repro.s3 MAXVALUE 1 MINVALUE 5;
CREATE TYPE repro.comp AS (a int, a text);
CREATE TYPE repro.comp2 AS (a int);
CREATE TYPE repro.comp2 AS (b int);
DROP TYPE repro.nope;
ALTER TYPE repro.comp2 ADD ATTRIBUTE a int;    -- dup attr
CREATE FUNCTION repro.addone(int) RETURNS int LANGUAGE sql AS 'SELECT $1';  -- dup
CREATE FUNCTION repro.f() RETURNS int LANGUAGE nosuchlang AS 'x';
CREATE FUNCTION repro.f2() RETURNS nosuchtype LANGUAGE sql AS 'SELECT 1';
DROP FUNCTION repro.nope();
CREATE AGGREGATE repro.badagg (int) (SFUNC = nosuchfn, STYPE = int);
CREATE OPERATOR repro.### (LEFTARG = int, RIGHTARG = int, PROCEDURE = nosuchfn);
DROP OPERATOR repro.+(int, int);
CREATE COLLATION repro.badcoll (LOCALE = 'nonexistent_xyz');
CREATE COLLATION repro.c2 (nonexistent_param = 'x');
ALTER TABLE repro.child INHERIT repro.parent;
CREATE TABLE repro.pt (a int) PARTITION BY RANGE (a);
CREATE TABLE repro.pt_p1 PARTITION OF repro.pt FOR VALUES FROM (10) TO (1);
CREATE TABLE repro.pt_p2 PARTITION OF repro.pt FOR VALUES FROM (1) TO (5);
CREATE TABLE repro.pt_p3 PARTITION OF repro.pt FOR VALUES FROM (3) TO (8);
ALTER TABLE repro.pt ADD PRIMARY KEY (a);
CREATE TABLE repro.pt_bad PARTITION OF repro.pt DEFAULT;
CREATE TABLE repro.pt_bad2 PARTITION OF repro.pt DEFAULT;
CREATE TABLE repro.notpart_p PARTITION OF repro.parent FOR VALUES FROM (1) TO (2);
