-- Constraints, partitioning and inheritance DDL
-- -> src/backend/commands/tablecmds.c, catalog/heap.c, catalog/index.c,
--    commands/indexcmds.c, partitioning/partbounds.c, parser/parse_utilcmd.c
--
-- Distinct sites beyond those hit by 04/21/27. Objects created inline under s36.

CREATE SCHEMA s36;

-- Primary keys: multiple PKs at CREATE and via ALTER (parse_utilcmd 2358 / index.c 221)
CREATE TABLE s36.mpk2 (a int PRIMARY KEY, b int PRIMARY KEY);
CREATE TABLE s36.mpk (a int, b int);
ALTER TABLE s36.mpk ADD PRIMARY KEY (a);
ALTER TABLE s36.mpk ADD PRIMARY KEY (b);

-- NOT NULL added over existing NULL data (tablecmds 6599)
CREATE TABLE s36.nn (a int);
INSERT INTO s36.nn VALUES (NULL), (1);
ALTER TABLE s36.nn ALTER COLUMN a SET NOT NULL;

-- CHECK constraint restrictions (parse_expr / parse_utilcmd)
CREATE TABLE s36.cks (a int CHECK (a IN (SELECT 1)));
CREATE TABLE s36.ckv (a int CHECK (a > (SELECT max(id) FROM s36.mpk)));

-- Identity column conflicts (tablecmds 7926 / 8461 / 8467 / 8294)
CREATE TABLE s36.idt (a int GENERATED ALWAYS AS IDENTITY, b int);
ALTER TABLE s36.idt ALTER COLUMN a ADD GENERATED ALWAYS AS IDENTITY;  -- already identity
ALTER TABLE s36.idt ALTER COLUMN a SET DEFAULT 5;                     -- is an identity column
ALTER TABLE s36.idt ALTER COLUMN b SET DEFAULT 5;
ALTER TABLE s36.idt ALTER COLUMN b ADD GENERATED ALWAYS AS IDENTITY;  -- already has a default value

-- Generated columns (heap.c 3300 / 3368)
CREATE TABLE s36.gvol (a int, b timestamptz GENERATED ALWAYS AS (now()) STORED);
CREATE FUNCTION s36.udf(int) RETURNS int LANGUAGE sql IMMUTABLE AS 'SELECT $1';
CREATE TABLE s36.gudf (a int, b int GENERATED ALWAYS AS (s36.udf(a)) STORED);

-- Exclusion + foreign key type/definition errors (indexcmds 2209, tablecmds 10580)
CREATE TABLE s36.exc (a int, EXCLUDE USING btree (a WITH &&));
CREATE TABLE s36.pkt (id int PRIMARY KEY);
CREATE TABLE s36.fkt (r text);
ALTER TABLE s36.fkt ADD FOREIGN KEY (r) REFERENCES s36.pkt (id);      -- incompatible types

-- Temporal FK: PERIOD required when referencing WITHOUT OVERLAPS key (tablecmds 10375)
CREATE TABLE s36.per (id int, valid daterange, PRIMARY KEY (id, valid WITHOUT OVERLAPS));
CREATE TABLE s36.perfk (id int, valid daterange,
    FOREIGN KEY (id, valid) REFERENCES s36.per (id, valid));

-- Partition key restrictions (tablecmds 20551 / 20565 / 20698 / 20707)
CREATE TABLE s36.pk_gen (a int, b int GENERATED ALWAYS AS (a) STORED) PARTITION BY RANGE (b);
CREATE TABLE s36.pk_sys (a int) PARTITION BY RANGE (xmin);
CREATE TABLE s36.pk_const (a int) PARTITION BY RANGE ((1));
CREATE TABLE s36.pk_vol (a timestamptz) PARTITION BY RANGE ((now()));

-- Hash-partition modulus/remainder bounds (partbounds 4795 / 4799 / 4803)
CREATE TABLE s36.hp (a int) PARTITION BY HASH (a);
CREATE TABLE s36.hp0 PARTITION OF s36.hp FOR VALUES WITH (MODULUS 0, REMAINDER 0);
CREATE TABLE s36.hp1 PARTITION OF s36.hp FOR VALUES WITH (MODULUS 4, REMAINDER 5);
CREATE TABLE s36.hp2 PARTITION OF s36.hp FOR VALUES WITH (MODULUS 4, REMAINDER -1);

-- Range-partition bound errors (partbounds 4856 / 3230, tablecmds strategy mismatch)
CREATE TABLE s36.rp (a int) PARTITION BY RANGE (a);
CREATE TABLE s36.rp1 PARTITION OF s36.rp FOR VALUES FROM ('x') TO ('z');   -- bound type mismatch
CREATE TABLE s36.rp2 PARTITION OF s36.rp FOR VALUES IN (1);                -- wrong bound kind
CREATE TABLE s36.rp_a PARTITION OF s36.rp FOR VALUES FROM (1) TO (10);
CREATE TABLE s36.rp_b PARTITION OF s36.rp FOR VALUES FROM (5) TO (15);     -- would overlap

-- ATTACH column mismatch (tablecmds 18984 / 19004 / 19018 / 21070)
CREATE TABLE s36.p (a int, b text) PARTITION BY RANGE (a);
CREATE TABLE s36.miss (a int);
ALTER TABLE s36.p ATTACH PARTITION s36.miss FOR VALUES FROM (1) TO (10);
CREATE TABLE s36.extra (a int, b text, c int);
ALTER TABLE s36.p ATTACH PARTITION s36.extra FOR VALUES FROM (10) TO (20);
CREATE TABLE s36.difftype (a text, b text);
ALTER TABLE s36.p ATTACH PARTITION s36.difftype FOR VALUES FROM (20) TO (30);
CREATE TYPE s36.rt AS (a int, b text);
CREATE TABLE s36.typedchild OF s36.rt;
ALTER TABLE s36.p ATTACH PARTITION s36.typedchild FOR VALUES FROM (30) TO (40);

-- Inheritance (tablecmds 18012 / 18321 / 19004 / 9485 / 18041, heap.c 3145)
CREATE TABLE s36.parent1 (a int, b text);
CREATE TABLE s36.parentpart (a int) PARTITION BY RANGE (a);
CREATE TABLE s36.cinh () INHERITS (s36.parentpart);
CREATE TABLE s36.ci1 (a int);
ALTER TABLE s36.ci1 INHERIT s36.parentpart;
CREATE TABLE s36.cmiss (a int);
ALTER TABLE s36.cmiss INHERIT s36.parent1;
CREATE TABLE s36.cdiff (a text, b text);
ALTER TABLE s36.cdiff INHERIT s36.parent1;
CREATE TABLE s36.inhparent (a int);
CREATE TABLE s36.inhchild (a int) INHERITS (s36.inhparent);
ALTER TABLE s36.inhchild DROP COLUMN a;
ALTER TABLE s36.inhparent INHERIT s36.inhchild;
CREATE TABLE s36.mi1 (x int);
CREATE TABLE s36.mi2 (x text);
CREATE TABLE s36.mic () INHERITS (s36.mi1, s36.mi2);
