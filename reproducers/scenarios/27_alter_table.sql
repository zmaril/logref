-- ALTER TABLE subcommand surface (tablecmds.c) — many distinct rejections.
CREATE TABLE repro.at (a int, b text, c int DEFAULT 0);
INSERT INTO repro.at VALUES (1,'x',1),(2,'y',2);
CREATE TABLE repro.at_part (a int) PARTITION BY LIST (a);
CREATE TABLE repro.at_reg (a int);
ALTER TABLE repro.at ADD COLUMN a int;                       -- dup
ALTER TABLE repro.at ADD COLUMN d int NOT NULL;              -- ok? has rows -> needs default; fine actually
ALTER TABLE repro.at ADD COLUMN e int PRIMARY KEY;
ALTER TABLE repro.at ADD COLUMN f serial;
ALTER TABLE repro.at ADD COLUMN g int GENERATED ALWAYS AS (a) STORED, ADD COLUMN h int GENERATED ALWAYS AS (g) STORED;
ALTER TABLE repro.at ALTER COLUMN a SET DEFAULT 'notanint';
ALTER TABLE repro.at ALTER COLUMN a DROP DEFAULT, ALTER COLUMN a SET DEFAULT nextval('nope');
ALTER TABLE repro.at ALTER COLUMN a SET NOT NULL;            -- ok
ALTER TABLE repro.at ALTER COLUMN a DROP IDENTITY;
ALTER TABLE repro.at ALTER COLUMN a ADD GENERATED ALWAYS AS IDENTITY;
ALTER TABLE repro.at ALTER COLUMN b TYPE int;
ALTER TABLE repro.at ALTER COLUMN a TYPE int USING nosuchcol;
ALTER TABLE repro.at ALTER COLUMN a SET STORAGE nonsense;
ALTER TABLE repro.at ALTER COLUMN a SET STORAGE MAIN;         -- int can't be toasted -> error path
ALTER TABLE repro.at ALTER COLUMN a SET COMPRESSION nonsense;
ALTER TABLE repro.at ALTER COLUMN a SET (n_distinct = 'x');
ALTER TABLE repro.at ALTER COLUMN a SET STATISTICS 100000;
ALTER TABLE repro.at ALTER COLUMN a SET STATISTICS -5;
ALTER TABLE repro.at ALTER COLUMN nope SET STATISTICS 10;
ALTER TABLE repro.at DROP COLUMN a;                          -- pk/generated dep chain
ALTER TABLE repro.at DROP COLUMN g;
ALTER TABLE repro.at RENAME TO at;                           -- to self? ok
ALTER TABLE repro.at RENAME TO parent;                       -- name in use
ALTER TABLE repro.at SET SCHEMA repro;                       -- same schema
ALTER TABLE repro.at SET TABLESPACE nonexistent_ts;
ALTER TABLE repro.at SET (nonexistent_reloption = 1);
ALTER TABLE repro.at SET (fillfactor = 5000);
ALTER TABLE repro.at SET (autovacuum_enabled = maybe);
ALTER TABLE repro.at RESET (nonexistent_reloption);
ALTER TABLE repro.at SET LOGGED;
ALTER TABLE repro.at SET UNLOGGED;
ALTER TABLE repro.at INHERIT repro.parent;
ALTER TABLE repro.at NO INHERIT repro.parent;                -- not a parent
ALTER TABLE repro.at OF repro.nonexistent_type;
ALTER TABLE repro.at ADD CONSTRAINT ck CHECK (nosuchcol > 0);
ALTER TABLE repro.at ADD CONSTRAINT ck2 CHECK (b > 0) NOT VALID;
ALTER TABLE repro.at VALIDATE CONSTRAINT nonexistent_con;
ALTER TABLE repro.at DROP CONSTRAINT nonexistent_con;
ALTER TABLE repro.at ADD PRIMARY KEY (b);
ALTER TABLE repro.at ADD UNIQUE (nosuchcol);
ALTER TABLE repro.at ADD FOREIGN KEY (b) REFERENCES repro.parent (label);
ALTER TABLE repro.at ADD EXCLUDE USING btree (b WITH =);
ALTER TABLE repro.at CLUSTER ON nonexistent_idx;
ALTER TABLE repro.at SET WITHOUT CLUSTER;
ALTER TABLE repro.at ENABLE TRIGGER nonexistent_trg;
ALTER TABLE repro.at DISABLE RULE nonexistent_rule;
ALTER TABLE repro.at FORCE ROW LEVEL SECURITY;
ALTER TABLE repro.at REPLICA IDENTITY USING INDEX nonexistent_idx;
ALTER TABLE repro.at_part ATTACH PARTITION repro.at FOR VALUES IN (1);
ALTER TABLE repro.at_part ATTACH PARTITION repro.nonexistent FOR VALUES IN (1);
ALTER TABLE repro.at_part DETACH PARTITION repro.at_reg;
ALTER TABLE repro.parent ATTACH PARTITION repro.at FOR VALUES IN (1);
ALTER TABLE repro.child_v ADD COLUMN z int;
ALTER TABLE repro.child_v ALTER COLUMN id SET DEFAULT 1;
ALTER INDEX child_amount_idx ALTER COLUMN 1 SET STATISTICS 10;
ALTER INDEX child_amount_idx SET (fillfactor = 5000);
ALTER TABLE ONLY repro.parent ADD COLUMN zz int;
ALTER TABLE repro.at ADD COLUMN arr int[] DEFAULT '{{1}}';
ALTER TABLE repro.at ALTER COLUMN b TYPE varchar(1);
ALTER TABLE repro.at ADD GENERATED ALWAYS AS IDENTITY;
ALTER MATERIALIZED VIEW repro.parent RENAME TO x;
ALTER FOREIGN TABLE repro.parent OPTIONS (x 'y');
ALTER SEQUENCE repro.churn_id_seq AS int2;
ALTER SEQUENCE repro.churn_id_seq RESTART WITH -5 INCREMENT 0;
ALTER SEQUENCE nonexistent_seq RESTART;
