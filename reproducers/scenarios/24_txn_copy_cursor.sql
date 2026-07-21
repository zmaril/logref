-- Transaction/savepoint/2PC, cursors, prepared statements, COPY, EXPLAIN, SET,
-- LOCK, sequences, LISTEN/NOTIFY, session state.
ROLLBACK TO SAVEPOINT nope;
SAVEPOINT sp;               -- outside a txn block -> WARNING/ERROR
RELEASE SAVEPOINT nope;
COMMIT PREPARED 'nope';
ROLLBACK PREPARED 'nope';
PREPARE TRANSACTION 'x';    -- no active txn
BEGIN; SAVEPOINT s1; ROLLBACK TO s2; RELEASE s2; COMMIT;
BEGIN; SELECT 1/0; SELECT 1; COMMIT;   -- in-failed-transaction
BEGIN; PREPARE TRANSACTION 'p1'; COMMIT PREPARED 'p1'; COMMIT PREPARED 'p1';
SET TRANSACTION ISOLATION LEVEL bogus;
SET TRANSACTION SNAPSHOT 'FFFFFFFF-1-1';
BEGIN; SET TRANSACTION READ ONLY; INSERT INTO repro.parent VALUES (99,'x'); ROLLBACK;
DECLARE c CURSOR FOR SELECT 1;             -- no txn -> not held
DECLARE c NO SCROLL CURSOR FOR SELECT 1; FETCH BACKWARD FROM c;
BEGIN; DECLARE c1 CURSOR FOR SELECT 1; FETCH c1; FETCH nosuchcursor; MOVE nosuchcursor; CLOSE nosuchcursor; COMMIT;
FETCH FROM alsonone;
PREPARE p1 AS SELECT $1::int;
PREPARE p1 AS SELECT 1;             -- dup
EXECUTE p1;                         -- wrong param count
EXECUTE p1(1, 2);
EXECUTE nosuchprep(1);
DEALLOCATE nosuchprep;
PREPARE p2 AS SELECT $1::int + $2::int; EXECUTE p2('a', 'b');
LOCK TABLE repro.nope;
LOCK TABLE repro.parent IN nonsense MODE;
LOCK TABLE repro.child_v IN ACCESS EXCLUSIVE MODE;
BEGIN; LOCK TABLE repro.parent IN ACCESS SHARE MODE NOWAIT; COMMIT;
SELECT nextval('repro.nope');
SELECT currval('repro.churn_id_seq');   -- currval before nextval in session
SELECT setval('repro.churn_id_seq', 0);
SELECT setval('repro.nope', 1);
SELECT nextval('repro.child_v');
COPY repro.nope TO STDOUT;
COPY repro.parent (nosuchcol) TO STDOUT;
COPY repro.parent TO STDOUT (FORMAT nonsense);
COPY repro.parent TO STDOUT (FORMAT binary, DELIMITER ',');
COPY repro.parent TO STDOUT (FORMAT csv, QUOTE 'xx');
COPY repro.parent TO STDOUT (FORMAT csv, HEADER match);
COPY repro.parent TO STDOUT (ENCODING 'NOSUCH');
COPY repro.parent FROM STDIN (FORMAT csv, FORCE_NOT_NULL (nosuchcol));
COPY (SELECT 1) TO STDOUT (FORMAT csv, FORCE_QUOTE (a));
COPY repro.child_v TO STDOUT;
COPY repro.parent TO '/nonexistent_dir/x.csv';
EXPLAIN (FORMAT nonsense) SELECT 1;
EXPLAIN (ANALYZE, COSTS off, NOSUCHOPT) SELECT 1;
EXPLAIN (BUFFERS) SELECT 1;
EXPLAIN (SERIALIZE, FORMAT text) SELECT 1;
EXPLAIN (GENERIC_PLAN, ANALYZE) SELECT 1;
EXPLAIN EXECUTE nosuchprep;
LISTEN;
NOTIFY;
UNLISTEN nosuch;
SELECT pg_notify('', 'x');
RESET nonexistent.guc;
SET LOCAL nosuch.guc = 1;
DISCARD nonsense;
