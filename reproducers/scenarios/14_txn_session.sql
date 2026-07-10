-- Transaction / cursor / prepared-statement / session errors  ->  src/backend/{tcop,commands,access/transam}/**
-- Misuse of transaction control, cursors, prepared statements, LOCK, SET and
-- COPY. These reach the top-level command handlers and the xact machinery.

COMMIT;
ROLLBACK;
END;
SAVEPOINT sp1;
RELEASE SAVEPOINT nope;
ROLLBACK TO SAVEPOINT nope;
BEGIN;
SAVEPOINT sp1;
RELEASE SAVEPOINT sp_missing;
ROLLBACK TO sp_missing;
COMMIT;
ROLLBACK TO sp1;

PREPARE p1 AS SELECT $1::int;
PREPARE p1 AS SELECT 1;
EXECUTE p1;
EXECUTE p1(1, 2, 3);
EXECUTE nonexistent_prepared;
DEALLOCATE nonexistent_prepared;

DECLARE c1 CURSOR FOR SELECT 1;
FETCH c1;
CLOSE c1;
FETCH nonexistent_cursor;
CLOSE nonexistent_cursor;
MOVE nonexistent_cursor;

BEGIN;
DECLARE c2 CURSOR FOR SELECT * FROM repro.parent;
FETCH 1000000 FROM c2;
FETCH ABSOLUTE -1 FROM c2;
COMMIT;
FETCH c2;

LOCK TABLE nonexistent_table;
LOCK TABLE repro.parent IN NONSENSE MODE;
SET nonexistent_parameter = 1;
SET work_mem = 'notasize';
SET statement_timeout = 'abc';
SET datestyle = 'nonsense';
SET search_path = repro, missing_schema;
RESET nonexistent_parameter;
SHOW nonexistent_parameter;
SELECT set_config('nonexistent.param', 'x', false);

COPY repro.parent FROM STDIN WITH (FORMAT nonexistent);
COPY repro.parent (nope) TO STDOUT;
COPY (SELECT 1) FROM STDIN;
COPY repro.nonexistent TO STDOUT;
DISCARD nonsense;
VACUUM (NONEXISTENT_OPTION) repro.parent;
CLUSTER repro.parent;
