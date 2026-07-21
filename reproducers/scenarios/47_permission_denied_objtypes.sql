-- Privilege ENFORCEMENT (permission-denied / must-be-owner)  ->  src/backend/catalog/aclchk.c (aclcheck_error), src/backend/commands/**
-- A superuser bypasses every privilege check, so the point of this file is the
-- SET ROLE into an unprivileged role: each denied operation fires aclcheck_error
-- (permission denied for <object>) or the ownership check (must be owner of ...).
-- Schema USAGE is granted so object-level denials surface instead of a blanket
-- schema-usage denial. Idempotent for the shared cluster.

-- unprivileged role + object zoo (superuser).
DO $$ BEGIN CREATE ROLE acl_low NOLOGIN; EXCEPTION WHEN duplicate_object THEN NULL; END $$;
CREATE SCHEMA IF NOT EXISTS acl47;
CREATE TABLE IF NOT EXISTS acl47.t (a int, b text);
CREATE SEQUENCE IF NOT EXISTS acl47.s;
CREATE OR REPLACE FUNCTION acl47.f() RETURNS int LANGUAGE sql AS 'SELECT 1';
GRANT USAGE ON SCHEMA acl47 TO acl_low;
REVOKE ALL ON acl47.t FROM acl_low;
REVOKE ALL ON SEQUENCE acl47.s FROM acl_low;
REVOKE ALL ON FUNCTION acl47.f() FROM acl_low;
REVOKE CREATE ON SCHEMA acl47 FROM acl_low;

SET ROLE acl_low;

-- DML / access denied for the object (aclcheck_error: permission denied for X).
SELECT * FROM acl47.t;
INSERT INTO acl47.t VALUES (1, 'x');
UPDATE acl47.t SET b = 'y';
DELETE FROM acl47.t;
TRUNCATE acl47.t;
SELECT nextval('acl47.s');
SELECT acl47.f();

-- no CREATE on the schema / no CREATE on the database.
CREATE TABLE acl47.mine (a int);
CREATE SCHEMA acl_low_schema;

-- server-side COPY to/from a file needs a privileged role (copy.c / miscinit.c).
COPY acl47.t TO '/tmp/acl47_out.csv';
COPY acl47.t FROM '/tmp/acl47_in.csv';

-- must be owner of the object (aclcheck_error: ACLCHECK_NOT_OWNER, or a
-- command-specific ownership ereport).
ALTER TABLE acl47.t ADD COLUMN c int;
DROP TABLE acl47.t;
ALTER SEQUENCE acl47.s INCREMENT BY 2;
ALTER FUNCTION acl47.f() STABLE;
COMMENT ON TABLE acl47.t IS 'nope';
CREATE INDEX acl_low_idx ON acl47.t (a);

RESET ROLE;
