-- Integrity constraint violations  ->  src/backend/executor/**, access/**, commands/**
-- Relies on the tables created in 00_setup.sql. Each statement trips a distinct
-- constraint: NOT NULL, unique, primary key, foreign key (both directions),
-- and CHECK.

-- NOT NULL
INSERT INTO repro.parent (id, label) VALUES (99, NULL);
UPDATE repro.parent SET label = NULL WHERE id = 1;
INSERT INTO repro.child (id) VALUES (NULL);

-- unique / primary key
INSERT INTO repro.parent (id, label) VALUES (1, 'dup');
INSERT INTO repro.child (id, parent_id, amount, email) VALUES (12, 1, 5, 'a@example.com');
INSERT INTO repro.child (id, parent_id, amount, email) VALUES (10, 1, 5, 'z@example.com');

-- CHECK
INSERT INTO repro.child (id, parent_id, amount) VALUES (13, 1, -5);
UPDATE repro.child SET amount = -1 WHERE id = 10;

-- foreign key: insert referencing a missing parent
INSERT INTO repro.child (id, parent_id, amount) VALUES (14, 999, 1);
-- foreign key: delete a still-referenced parent
DELETE FROM repro.parent WHERE id = 1;
UPDATE repro.parent SET id = 500 WHERE id = 2;

-- CHECK constraint added to existing bad data
CREATE TABLE repro.badcheck (n int);
INSERT INTO repro.badcheck VALUES (-1), (-2);
ALTER TABLE repro.badcheck ADD CONSTRAINT n_pos CHECK (n > 0);

-- NOT NULL added to a column that has nulls
CREATE TABLE repro.hasnull (n int);
INSERT INTO repro.hasnull VALUES (NULL);
ALTER TABLE repro.hasnull ALTER COLUMN n SET NOT NULL;

-- primary key on duplicate data
CREATE TABLE repro.dupkey (n int);
INSERT INTO repro.dupkey VALUES (1), (1);
ALTER TABLE repro.dupkey ADD PRIMARY KEY (n);

-- generated / identity misuse
CREATE TABLE repro.idt (id int GENERATED ALWAYS AS IDENTITY, v int);
INSERT INTO repro.idt (id, v) VALUES (5, 5);

-- exclusion-style: not-deferrable unique in one statement
INSERT INTO repro.parent (id, label) VALUES (7, 'x'), (7, 'y');
