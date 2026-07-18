-- Query-semantics / planner / rewrite errors  ->  src/backend/parser/parse_*.c, optimizer/**, rewrite/**
-- Statements that parse but are semantically illegal: aggregate/GROUP BY misuse,
-- set-operation type mismatches, subquery cardinality, ambiguous references,
-- window/ordering misuse.

SELECT id, count(*) FROM repro.child;
SELECT amount FROM repro.child GROUP BY id;
SELECT sum(amount), amount FROM repro.child;
SELECT count(*) FROM repro.child WHERE count(*) > 0;
SELECT count(count(*)) FROM repro.child;
SELECT * FROM repro.child HAVING amount > 0;
SELECT (SELECT id FROM repro.parent);
SELECT * FROM repro.parent WHERE id = (SELECT id FROM repro.parent);
SELECT 1 UNION SELECT 'x';
SELECT ARRAY[1,2] UNION SELECT ARRAY['a','b'];
SELECT id FROM repro.parent UNION SELECT id, label FROM repro.parent;
SELECT * FROM repro.parent, repro.child ORDER BY id;
SELECT id FROM repro.parent p JOIN repro.child c ON true WHERE id = 1;
SELECT nonagg, sum(amount) FROM (SELECT amount AS nonagg, amount FROM repro.child) s;
SELECT rank() FROM repro.child;
SELECT row_number() OVER (ORDER BY nope) FROM repro.child;
SELECT sum(amount) OVER (PARTITION BY count(*)) FROM repro.child;
SELECT DISTINCT ON (id) * FROM repro.child ORDER BY amount;
SELECT amount FROM repro.child ORDER BY 99;
SELECT amount FROM repro.child GROUP BY 99;
SELECT * FROM repro.parent FOR UPDATE OF nonexistent;
SELECT * FROM repro.parent LIMIT 'x';
SELECT * FROM repro.parent LIMIT -1 OFFSET 'y';
SELECT * FROM generate_series(1,3) WITH ORDINALITY AS t(a,b,c);
INSERT INTO repro.parent (id) SELECT id, label FROM repro.parent;
INSERT INTO repro.parent (id, label) VALUES (1);
UPDATE repro.parent SET (id, label) = (1, 'a', 'b');
SELECT coalesce();
SELECT greatest();
SELECT nullif(1);
SELECT 1 IN ();
WITH RECURSIVE t AS (SELECT 1) SELECT * FROM t;
SELECT * FROM repro.parent TABLESAMPLE bernoulli(200);
SELECT grouping(id) FROM repro.parent;
SELECT * FROM ROWS FROM (generate_series(1,2), unnest(ARRAY['a'])) WITH ORDINALITY;
MERGE INTO repro.parent p USING repro.child c ON p.id = c.id;
