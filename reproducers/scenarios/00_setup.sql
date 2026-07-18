-- Setup + Tier-1 lifecycle triggers.
--
-- Creates the roles, schemas, tables and data that later scenarios lean on, and
-- deliberately exercises the maintenance/lifecycle commands whose LOG-level call
-- sites (checkpoint, vacuum, analyze, autovacuum) fire for free on any live
-- cluster. Statements here are meant to SUCCEED; the error scenarios come after.

CREATE ROLE lowpriv NOLOGIN;
CREATE ROLE otherrole NOLOGIN;
CREATE SCHEMA repro;

CREATE TABLE repro.parent (id int PRIMARY KEY, label text NOT NULL);
CREATE TABLE repro.child (
    id int PRIMARY KEY,
    parent_id int REFERENCES repro.parent(id),
    amount int CHECK (amount >= 0),
    email text UNIQUE
);
INSERT INTO repro.parent VALUES (1, 'one'), (2, 'two'), (3, 'three');
INSERT INTO repro.child VALUES (10, 1, 100, 'a@example.com'), (11, 2, 200, 'b@example.com');

CREATE INDEX child_amount_idx ON repro.child (amount);
CREATE VIEW repro.child_v AS SELECT id, amount FROM repro.child;
CREATE FUNCTION repro.addone(int) RETURNS int LANGUAGE sql AS 'SELECT $1 + 1';

-- Lifecycle / maintenance: these fire checkpoint, vacuum and analyze LOG sites.
CHECKPOINT;
VACUUM (VERBOSE, ANALYZE) repro.child;
VACUUM FULL repro.parent;
ANALYZE repro.parent;
REINDEX TABLE repro.child;
CLUSTER repro.child USING child_amount_idx;
CHECKPOINT;

-- A large-ish churn so autovacuum has something to do during the run.
CREATE TABLE repro.churn (id serial PRIMARY KEY, n int);
INSERT INTO repro.churn (n) SELECT g FROM generate_series(1, 20000) g;
UPDATE repro.churn SET n = n + 1;
DELETE FROM repro.churn WHERE id % 2 = 0;
VACUUM repro.churn;
ANALYZE repro.churn;
