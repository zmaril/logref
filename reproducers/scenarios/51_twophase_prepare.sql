-- Two-phase commit (PREPARE TRANSACTION / COMMIT|ROLLBACK PREPARED)  ->  src/backend/access/transam/twophase.c, src/backend/access/transam/xact.c
-- Misuse of the 2PC surface. This file is run TWICE by the measurement step:
--   * on a default cluster (max_prepared_transactions = 0) the basic prepares
--     hit "prepared transactions are disabled";
--   * on a cluster with max_prepared_transactions = 10 the deeper twophase.c
--     sites (gid too long, already in use, the cannot-PREPARE-that-has-* guards)
--     become reachable.
-- One file exercises both; statements that no-op on the wrong regime are fine
-- (ON_ERROR_STOP=0). Anything that succeeds on the max=10 run is cleaned up so
-- no prepared transaction is left dangling to block cluster shutdown.

-- PREPARE TRANSACTION outside a transaction block
-- ("PREPARE TRANSACTION can only be used in transaction blocks" — xact.c).
PREPARE TRANSACTION 'g_outside';

-- Basic prepare with real work: "disabled" on max=0, a live prepared xact on
-- max=10 (twophase.c MarkAsPreparing / RegisterGXact). Cleaned up below.
BEGIN;
INSERT INTO repro.parent VALUES (901, 'twopc-a');
PREPARE TRANSACTION 'g1';

-- Same gid a second time: on max=10 this is "transaction identifier \"g1\" is
-- already in use"; on max=0 it is "disabled" again.
BEGIN;
INSERT INTO repro.parent VALUES (902, 'twopc-b');
PREPARE TRANSACTION 'g1';

-- gid longer than GIDSIZE (200) -> "transaction identifier \"%s\" is too long".
BEGIN;
SELECT 1;
PREPARE TRANSACTION 'gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg_toolong';
ROLLBACK;

-- Empty gid.
BEGIN;
SELECT 1;
PREPARE TRANSACTION '';
ROLLBACK;

-- COMMIT / ROLLBACK PREPARED for a gid that does not exist (twophase.c LockGXact
-- -> "prepared transaction with identifier \"%s\" does not exist").
COMMIT PREPARED 'no_such_gid';
ROLLBACK PREPARED 'no_such_gid';

-- cannot-PREPARE-that-has-* guards (xact.c PrepareTransaction). These run before
-- MarkAsPreparing, so they fire even on the max=0 regime.
-- ... operated on temporary objects.
BEGIN;
CREATE TEMP TABLE tmp_2pc (x int);
INSERT INTO tmp_2pc VALUES (1);
PREPARE TRANSACTION 'g_temp';
ROLLBACK;
-- ... created a cursor WITH HOLD.
BEGIN;
DECLARE hold_cur CURSOR WITH HOLD FOR SELECT * FROM repro.parent;
PREPARE TRANSACTION 'g_cursor';
ROLLBACK;
-- ... has exported snapshots.
BEGIN;
SELECT pg_export_snapshot();
PREPARE TRANSACTION 'g_snap';
ROLLBACK;
-- ... holds a session-level advisory lock (AtPrepare_Locks).
BEGIN;
SELECT pg_advisory_lock(4242);
PREPARE TRANSACTION 'g_adv';
ROLLBACK;
SELECT pg_advisory_unlock(4242);

-- COMMIT / ROLLBACK PREPARED inside a transaction block
-- (xact.c PreventInTransactionBlock -> "cannot ... inside a transaction block").
BEGIN;
COMMIT PREPARED 'g_inblock';
ROLLBACK;
BEGIN;
ROLLBACK PREPARED 'g_inblock';
ROLLBACK;

-- Cleanup: on the max=10 run 'g1' is a live prepared xact — commit it, then the
-- rollback finds it gone ("does not exist"). On max=0 both just report gone.
COMMIT PREPARED 'g1';
ROLLBACK PREPARED 'g1';
