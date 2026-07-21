-- Transaction control, savepoints & snapshot import  ->  src/backend/access/transam/xact.c, src/backend/utils/time/snapmgr.c
-- Misuse of BEGIN/COMMIT/ROLLBACK/SAVEPOINT/SET TRANSACTION that reaches the
-- transaction-block state machine and the snapshot importer. These are the
-- WARNING/ERROR call sites 14_txn_session.sql and 24_txn_copy_cursor.sql do NOT
-- reach: "already a transaction in progress", the AND CHAIN edges, the
-- must-be-called-before-any-query guards, ImportSnapshot's parse/lookup errors,
-- and the nested savepoint stack. In-transaction cases are wrapped in real
-- BEGIN;...;ROLLBACK; blocks so the right blockState is set when the site fires.

-- No transaction in progress (xact.c EndTransactionBlock / UserAbortTransactionBlock).
-- 14 already fires the plain COMMIT/ROLLBACK/END forms; these add ABORT and the
-- AND CHAIN variants, which take a different path through the block machinery.
ABORT;
COMMIT AND CHAIN;
ROLLBACK AND CHAIN;
END AND CHAIN;

-- Already in a transaction (xact.c BeginTransactionBlock WARNING).
BEGIN;
BEGIN;
COMMIT;
START TRANSACTION;
START TRANSACTION;
COMMIT;

-- COMMIT AND CHAIN out of an already-aborted block.
BEGIN;
SELECT 1/0;
COMMIT AND CHAIN;
ROLLBACK;

-- SET TRANSACTION ISOLATION LEVEL / characteristics after a query has run
-- ("SET TRANSACTION ... must be called before any query" — xact.c/guc check_XactIsoLevel).
BEGIN;
SELECT 1;
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
ROLLBACK;
BEGIN;
SELECT 1;
SET TRANSACTION READ ONLY;
ROLLBACK;
BEGIN;
SELECT 1;
SET TRANSACTION DEFERRABLE;
ROLLBACK;
BEGIN;
SELECT 1;
SET transaction_isolation = 'serializable';
ROLLBACK;

-- SET TRANSACTION ... outside a transaction block
-- (WARNING "SET TRANSACTION can only be used in transaction blocks").
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET TRANSACTION READ ONLY;
SET TRANSACTION DEFERRABLE;

-- SET TRANSACTION SNAPSHOT (snapmgr.c ImportSnapshot + xact.c guards).
-- Garbage id: parse failure -> "invalid snapshot identifier".
BEGIN ISOLATION LEVEL REPEATABLE READ;
SET TRANSACTION SNAPSHOT 'garbage';
ROLLBACK;
-- Well-formed but unknown id: lookup failure -> "snapshot ... does not exist".
BEGIN ISOLATION LEVEL REPEATABLE READ;
SET TRANSACTION SNAPSHOT '00000003-0000001B-1';
ROLLBACK;
-- After a query: "SET TRANSACTION SNAPSHOT must be called before any query".
BEGIN ISOLATION LEVEL REPEATABLE READ;
SELECT 1;
SET TRANSACTION SNAPSHOT '00000003-0000001B-1';
ROLLBACK;
-- Outside a transaction block entirely.
SET TRANSACTION SNAPSHOT '00000003-0000001B-1';

-- Nested savepoints then rollback/release to an outer name; the outer name is
-- then gone, so the follow-ups hit "savepoint \"%s\" does not exist"
-- (xact.c RollbackToSavepoint / ReleaseSavepoint).
BEGIN;
SAVEPOINT outer_sp;
SAVEPOINT mid_sp;
SAVEPOINT inner_sp;
ROLLBACK TO SAVEPOINT outer_sp;
RELEASE SAVEPOINT outer_sp;
RELEASE SAVEPOINT outer_sp;
ROLLBACK TO SAVEPOINT inner_sp;
COMMIT;

-- A valid savepoint, then RELEASE / ROLLBACK TO a different non-existent name.
BEGIN;
SAVEPOINT keeper;
RELEASE SAVEPOINT ghost_sp;
ROLLBACK TO SAVEPOINT ghost_sp;
COMMIT;
