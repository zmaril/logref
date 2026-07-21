-- Recursive/SEARCH/CYCLE CTE, WHERE CURRENT OF cursors, prepared-plan coercion, non-table LOCK -> parser/parse_cte.c, parser/parse_agg.c, executor/execCurrent.c, commands/prepare.c, commands/lockcmds.c
-- CTE structural validation (duplicate names, recursion placement of
-- OFFSET/LIMIT/FOR UPDATE, SEARCH/CYCLE column bookkeeping), cursor row
-- positioning for WHERE CURRENT OF, prepared-parameter type coercion, and
-- locking relation kinds that are not lockable tables.

-- WITH naming and column-list arity (parse_cte.c)
WITH t AS (SELECT 1), t AS (SELECT 2) SELECT * FROM t;
WITH t(a,b) AS (SELECT 1) SELECT * FROM t;
SELECT * FROM (WITH d AS (DELETE FROM repro.churn RETURNING id) SELECT id FROM d) s;

-- recursive-query placement restrictions (parse_cte.c / parse_agg.c)
WITH RECURSIVE a AS (SELECT * FROM b), b AS (SELECT * FROM a) SELECT * FROM a;
WITH RECURSIVE t AS (SELECT 1 AS n UNION ALL SELECT n+1 FROM t OFFSET 1) SELECT * FROM t;
WITH RECURSIVE t AS (SELECT 1 AS n UNION ALL SELECT n+1 FROM t LIMIT 5) SELECT * FROM t;
WITH RECURSIVE t AS (SELECT 1 AS n UNION ALL SELECT n+1 FROM t FOR UPDATE) SELECT * FROM t;
WITH RECURSIVE t AS (SELECT 1 AS n UNION ALL SELECT n+1 FROM t ORDER BY n) SELECT * FROM t;
WITH RECURSIVE t AS (SELECT 1 AS n UNION ALL SELECT count(*) FROM t) SELECT * FROM t;
WITH RECURSIVE t AS (SELECT 1 AS n UNION ALL SELECT n FROM t, t t2) SELECT * FROM t;
WITH RECURSIVE t AS (SELECT 1 AS n UNION ALL SELECT n FROM t WHERE n IN (SELECT n FROM t)) SELECT * FROM t;

-- SEARCH / CYCLE clause validation (parse_cte.c)
WITH RECURSIVE t(n) AS (SELECT 1) SEARCH DEPTH FIRST BY n SET s SELECT * FROM t;
WITH RECURSIVE t(n) AS (SELECT 1 UNION ALL SELECT n+1 FROM t WHERE n<3) SEARCH DEPTH FIRST BY nope SET s SELECT * FROM t;
WITH RECURSIVE t(n) AS (SELECT 1 UNION ALL SELECT n+1 FROM t WHERE n<3) SEARCH DEPTH FIRST BY n, n SET s SELECT * FROM t;
WITH RECURSIVE t(n) AS (SELECT 1 UNION ALL SELECT n+1 FROM t WHERE n<3) CYCLE nope SET c USING p SELECT * FROM t;
WITH RECURSIVE t(n) AS (SELECT 1 UNION ALL SELECT n+1 FROM t WHERE n<3) CYCLE n, n SET c USING p SELECT * FROM t;
WITH RECURSIVE t(n) AS (SELECT 1 UNION ALL SELECT n+1 FROM t WHERE n<3) CYCLE n SET c TO 1 DEFAULT 2 USING c SELECT * FROM t;
WITH RECURSIVE t(n) AS (SELECT 1 UNION ALL SELECT n+1 FROM t WHERE n<3) SEARCH DEPTH FIRST BY n SET s CYCLE n SET s USING p SELECT * FROM t;
WITH RECURSIVE t(n) AS (SELECT 1 UNION ALL SELECT n+1 FROM t WHERE n<3) SEARCH DEPTH FIRST BY n SET s CYCLE n SET c USING s SELECT * FROM t;

-- prepared-plan parameter coercion (prepare.c)
PREPARE pc(int) AS SELECT $1;
EXECUTE pc(ARRAY[1,2]);

-- LOCK on a relation kind that is not a lockable table (lockcmds.c)
BEGIN; LOCK TABLE repro.churn_id_seq IN ACCESS SHARE MODE; ROLLBACK;

-- WHERE CURRENT OF row positioning / updatability (execCurrent.c)
UPDATE repro.parent SET label='x' WHERE CURRENT OF nosuchcur;
BEGIN; DECLARE cs CURSOR FOR SELECT * FROM repro.parent ORDER BY label; FETCH cs; UPDATE repro.parent SET label='x' WHERE CURRENT OF cs; ROLLBACK;
BEGIN; DECLARE cp CURSOR FOR SELECT * FROM repro.parent; UPDATE repro.parent SET label='x' WHERE CURRENT OF cp; ROLLBACK;
BEGIN; DECLARE cf CURSOR FOR SELECT * FROM repro.parent FOR UPDATE OF parent; FETCH cf; UPDATE repro.child SET amount=1 WHERE CURRENT OF cf; ROLLBACK;
DECLARE ch CURSOR WITH HOLD FOR SELECT * FROM repro.parent;
UPDATE repro.parent SET label='x' WHERE CURRENT OF ch;
