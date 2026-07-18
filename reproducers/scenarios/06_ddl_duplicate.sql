-- Duplicate objects & illegal DDL  ->  src/backend/commands/**, catalog/**
-- Creating what already exists, dropping with dependents, and structurally
-- illegal ALTERs. Exercises the "already exists" / "depends on" / "cannot"
-- ereports in the command layer.

CREATE TABLE repro.parent (id int);
CREATE SCHEMA repro;
CREATE INDEX child_amount_idx ON repro.child (amount);
CREATE VIEW repro.child_v AS SELECT 1;
CREATE FUNCTION repro.addone(int) RETURNS int LANGUAGE sql AS 'SELECT 1';
CREATE ROLE lowpriv;
CREATE TYPE repro.parent AS (x int);
CREATE SEQUENCE repro.child_amount_idx;

-- duplicate column / constraint
ALTER TABLE repro.child ADD COLUMN amount int;
ALTER TABLE repro.child ADD CONSTRAINT child_pkey PRIMARY KEY (id);

-- drop with dependents (no CASCADE)
DROP TABLE repro.parent;
DROP SCHEMA repro;
DROP TYPE int4;

-- illegal type / structure changes
ALTER TABLE repro.child ALTER COLUMN email TYPE int USING email::int;
ALTER TABLE repro.child_v ADD COLUMN c int;
ALTER TABLE repro.parent ADD PRIMARY KEY (id), ADD PRIMARY KEY (label);
ALTER TABLE repro.parent INHERIT repro.child;
ALTER TABLE repro.parent SET SCHEMA repro;
ALTER TABLE repro.parent RENAME TO parent;

-- inheritance / partition misuse
CREATE TABLE repro.part (id int) PARTITION BY RANGE (id);
CREATE TABLE repro.p1 PARTITION OF repro.part FOR VALUES FROM (1) TO (10);
CREATE TABLE repro.p2 PARTITION OF repro.part FOR VALUES FROM (5) TO (15);
INSERT INTO repro.part VALUES (100);
ALTER TABLE repro.part DROP COLUMN id;

-- data type mismatch in DEFAULT / generated
CREATE TABLE repro.bad_default (n int DEFAULT 'notanumber');
CREATE TABLE repro.bad_gen (a int, b int GENERATED ALWAYS AS (a || 'x') STORED);

-- column with two defaults / bad collation
CREATE TABLE repro.bad_coll (t int COLLATE "C");
CREATE TABLE repro.recursive_default (n int DEFAULT (SELECT max(n) FROM repro.recursive_default));

-- tablespace / unsupported
CREATE TABLE repro.ts (id int) TABLESPACE nonexistent_ts;
CREATE UNLOGGED TABLE repro.u (id int);
CREATE TABLE repro.dup_col (a int, a int);
