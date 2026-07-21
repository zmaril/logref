-- Row marks, LOCK TABLE & advisory locks  ->  src/backend/parser/analyze.c, src/backend/commands/lockcmds.c, src/backend/storage/lmgr/lock.c, src/backend/utils/adt/lockfuncs.c
-- Parse-analyze restrictions on FOR UPDATE/SHARE (each a distinct CheckSelectLocking
-- / applyLockingClause / markQueryForLocking site in analyze.c), plus LOCK TABLE
-- misuse and advisory-lock ownership warnings. Contention-based lock.c sites
-- (deadlock, lock timeout, NOWAIT failure) need two sessions and live in the
-- companion driver 50_txn_concurrency.sh — this file is single-session only.

-- FOR UPDATE combined with clauses the row-mark analyzer rejects (analyze.c
-- CheckSelectLocking) — one ereport site per clause kind.
SELECT id FROM repro.child GROUP BY id FOR UPDATE;
SELECT id FROM repro.child GROUP BY id HAVING count(*) > 0 FOR UPDATE;
SELECT count(*) FROM repro.child FOR UPDATE;
SELECT id, row_number() OVER () FROM repro.child FOR UPDATE;
SELECT DISTINCT id FROM repro.child FOR UPDATE;
SELECT id FROM repro.child UNION SELECT id FROM repro.parent FOR UPDATE;
SELECT id FROM repro.child INTERSECT SELECT id FROM repro.parent FOR UPDATE;
SELECT id FROM repro.child EXCEPT SELECT id FROM repro.parent FOR UPDATE;

-- FOR UPDATE applied to a rowmark target that cannot be locked (analyze.c
-- applyLockingClause / transformLockingClause) — VALUES, function scan, the
-- nullable side of an outer join, and a WITH / recursive query.
SELECT * FROM (VALUES (1),(2)) v(x) FOR UPDATE;
SELECT * FROM generate_series(1, 3) g FOR UPDATE;
SELECT p.id FROM repro.parent p LEFT JOIN repro.child c ON c.parent_id = p.id FOR UPDATE OF c;
WITH cte AS (SELECT id FROM repro.child)
SELECT * FROM cte FOR UPDATE;
WITH RECURSIVE r(n) AS (SELECT 1 UNION ALL SELECT n + 1 FROM r WHERE n < 5)
SELECT * FROM r FOR UPDATE;

-- FOR UPDATE OF a relation not present in the FROM clause
-- ("relation \"%s\" in FOR UPDATE/SHARE clause not found in FROM clause").
SELECT id FROM repro.child FOR UPDATE OF nosuchrel;

-- FOR UPDATE against a relation kind that cannot carry row marks
-- (analyze.c markQueryForLocking -> "cannot lock rows in %s").
SELECT * FROM pg_locks FOR UPDATE;
SELECT * FROM repro.churn_id_seq FOR UPDATE;

-- LOCK TABLE misuse (lockcmds.c RangeVarCallbackForLockTable).
-- Non-existent relation (distinct name from 24's repro.nope).
BEGIN;
LOCK TABLE repro.definitely_absent IN SHARE MODE;
ROLLBACK;
-- LOCK TABLE with no explicit block (self-contained transaction).
LOCK TABLE repro.parent IN ACCESS EXCLUSIVE MODE;

-- Advisory-lock ownership warnings (lockfuncs.c) — unlocking a lock not held,
-- and unlocking with the wrong lock type. Each prints
-- WARNING "you don't own a lock of type %s".
SELECT pg_advisory_unlock(999);
SELECT pg_advisory_unlock_shared(999);
SELECT pg_advisory_unlock(1, 2);
-- Hold an exclusive advisory lock, then release it as shared (type mismatch).
SELECT pg_advisory_lock(777);
SELECT pg_advisory_unlock_shared(777);
SELECT pg_advisory_unlock(777);
-- A transaction-scoped advisory lock cannot be released by hand.
BEGIN;
SELECT pg_advisory_xact_lock(555);
SELECT pg_advisory_unlock(555);
ROLLBACK;
