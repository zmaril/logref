-- Privilege / role / ownership errors  ->  src/backend/catalog/aclchk.c, commands/**, libpq/**
-- Switches into a low-privilege role and attempts operations it is not allowed
-- to perform, then attempts illegal role/ownership changes. SET ROLE is
-- reset between clusters of statements.

SET ROLE lowpriv;
SELECT * FROM repro.parent;
INSERT INTO repro.parent VALUES (50, 'nope');
UPDATE repro.parent SET label = 'x';
DELETE FROM repro.child;
CREATE TABLE repro.sneaky (id int);
DROP TABLE repro.parent;
ALTER TABLE repro.parent ADD COLUMN c int;
TRUNCATE repro.child;
CREATE SCHEMA sneaky;
GRANT ALL ON repro.parent TO otherrole;
SELECT repro.addone(1);
RESET ROLE;

-- Role management errors as superuser.
CREATE ROLE lowpriv;
DROP ROLE lowpriv_missing;
ALTER ROLE nonexistent_role SUPERUSER;
GRANT lowpriv TO nonexistent_role;
REVOKE lowpriv FROM nonexistent_role;
SET ROLE nonexistent_role;
CREATE ROLE selfmember;
GRANT selfmember TO selfmember;

-- Ownership / reassignment errors.
ALTER TABLE repro.parent OWNER TO nonexistent_role;
REASSIGN OWNED BY nonexistent_role TO lowpriv;
DROP OWNED BY nonexistent_role;
ALTER SCHEMA repro OWNER TO nonexistent_role;

-- Superuser-only from a plain role.
SET ROLE lowpriv;
ALTER SYSTEM SET work_mem = '1MB';
COPY repro.parent TO '/tmp/out.csv';
COPY repro.parent FROM '/tmp/in.csv';
CREATE EXTENSION IF NOT EXISTS nonexistent_extension;
SET session_authorization = 'postgres';
RESET ROLE;
