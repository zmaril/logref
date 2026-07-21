-- Can't-run-in-a-txn-block commands, CLUSTER errors & statement timeouts  ->  src/backend/access/transam/xact.c (PreventInTransactionBlock), src/backend/commands/cluster.c, src/backend/commands/vacuum.c, src/backend/commands/indexcmds.c, src/backend/tcop/postgres.c (timeouts)
-- The maintenance commands that refuse to run inside a transaction block, plus
-- CLUSTER's index-selection errors and a couple of VACUUM option conflicts not
-- already covered by 34_guc_vacuum_copy_xml.sql, and the single-session
-- statement/transaction timeout cancel sites. Each cannot-run-in-block case is
-- wrapped in a real BEGIN;...;ROLLBACK; so PreventInTransactionBlock is reached
-- with the block actually open. Contention timeouts (lock_timeout, deadlock)
-- need two sessions and live in 50_txn_concurrency.sh.

-- Commands that error because a transaction block is open
-- (xact.c PreventInTransactionBlock; CIC/REINDEX CONCURRENTLY have their own
-- guards in indexcmds.c).
BEGIN;
VACUUM;
ROLLBACK;
BEGIN;
VACUUM FULL repro.churn;
ROLLBACK;
BEGIN;
VACUUM ANALYZE repro.churn;
ROLLBACK;
BEGIN;
CLUSTER repro.churn USING churn_pkey;
ROLLBACK;
BEGIN;
CREATE INDEX CONCURRENTLY cic_idx ON repro.churn (n);
ROLLBACK;
BEGIN;
REINDEX INDEX CONCURRENTLY churn_pkey;
ROLLBACK;
BEGIN;
REINDEX TABLE CONCURRENTLY repro.churn;
ROLLBACK;
BEGIN;
DROP INDEX CONCURRENTLY child_amount_idx;
ROLLBACK;
BEGIN;
ALTER TABLE repro.parent DETACH PARTITION repro.child CONCURRENTLY;
ROLLBACK;

-- CLUSTER index-selection errors (cluster.c). churn has never been clustered;
-- child WAS clustered in 00_setup, so use churn here.
CLUSTER repro.churn;
CLUSTER repro.churn USING no_such_index;
CLUSTER repro.churn USING child_amount_idx;

-- VACUUM / ANALYZE option conflicts not exercised by 34 (vacuum.c ExecVacuum).
VACUUM (FULL, BUFFER_USAGE_LIMIT '256kB') repro.churn;
VACUUM (FULL, PARALLEL 2) repro.churn;
ANALYZE (VERBOSE, SKIP_LOCKED) repro.nonexistent_analyze_tbl;

-- Statement timeout: the cancel fires at the source site in postgres.c
-- ProcessInterrupts ("canceling statement due to statement timeout").
SET statement_timeout = '20ms';
SELECT pg_sleep(2);
RESET statement_timeout;

-- Transaction timeout (PG17+; an unrecognized-GUC error on older servers, which
-- is itself a site). "canceling statement due to transaction timeout".
SET transaction_timeout = '50ms';
BEGIN;
SELECT pg_sleep(2);
COMMIT;
RESET transaction_timeout;
