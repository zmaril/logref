-- Planner/executor runtime + window-frame & FOR UPDATE placement errors -> src/backend/executor/{nodeLimit,nodeModifyTable,nodeSamplescan,nodeSubplan}.c, parser/{analyze,parse_clause}.c
-- Statements that survive analysis and fail at execution (negative LIMIT, scalar
-- subquery cardinality, ON CONFLICT/MERGE touching a row twice, TABLESAMPLE
-- REPEATABLE null) plus window-definition and locking-clause placement checks.

-- runtime cardinality: scalar subquery returns more than one row (nodeSubplan.c)
SELECT (SELECT g FROM generate_series(1,2) g);
SELECT * FROM repro.parent p WHERE p.id = (SELECT g FROM generate_series(1,5) g);

-- runtime LIMIT negativity, evaluated in nodeLimit.c (parse-time OK, exec fails)
SELECT * FROM repro.parent LIMIT (SELECT -1);
SELECT * FROM repro.parent LIMIT -1;

-- ON CONFLICT / MERGE affecting the same target row twice in one command (nodeModifyTable.c)
INSERT INTO repro.parent VALUES (1,'a'),(1,'b') ON CONFLICT (id) DO UPDATE SET label = excluded.label;
MERGE INTO repro.parent p USING (SELECT 1 AS k UNION ALL SELECT 1) s ON p.id = s.k WHEN MATCHED THEN UPDATE SET label = 'z';

-- TABLESAMPLE REPEATABLE seed evaluated at runtime, must be non-null (nodeSamplescan.c)
SELECT count(*) FROM repro.churn TABLESAMPLE bernoulli(50) REPEATABLE (NULL);
SELECT count(*) FROM repro.churn TABLESAMPLE system(10) REPEATABLE ('nan'::float8);

-- window definition merge/override checks (parse_clause.c)
SELECT sum(id) OVER w FROM repro.parent WINDOW w AS (ORDER BY id), w AS (ORDER BY label);
SELECT sum(id) OVER (w PARTITION BY id) FROM repro.parent WINDOW w AS (PARTITION BY label);
SELECT sum(id) OVER (w ORDER BY id) FROM repro.parent WINDOW w AS (ORDER BY label);

-- window frame mode validation (parse_clause.c)
SELECT sum(id) OVER (GROUPS BETWEEN 1 PRECEDING AND CURRENT ROW) FROM repro.parent;
SELECT sum(id) OVER (ORDER BY label RANGE BETWEEN 1 PRECEDING AND CURRENT ROW) FROM repro.parent;

-- locking clause not allowed with set-op / DISTINCT / window (analyze.c)
SELECT id FROM repro.parent UNION SELECT id FROM repro.child FOR UPDATE;
SELECT DISTINCT id FROM repro.parent FOR UPDATE;
SELECT id, sum(id) OVER () FROM repro.parent FOR UPDATE;
