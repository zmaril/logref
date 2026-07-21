-- GRANT/REVOKE privilege-type & structural errors  ->  src/backend/catalog/aclchk.c, src/backend/utils/adt/acl.c
-- Superuser-driven: builds a small object zoo, then fires the GRANT/REVOKE
-- validation ereports — invalid privilege type per object class, grant-option
-- to PUBLIC, column-privilege structural errors, relkind mismatches in
-- ExecGrant_Relation, and aclitem input parsing. Idempotent so it survives
-- re-runs in the shared cluster.

-- object zoo (superuser).
CREATE SCHEMA IF NOT EXISTS acl46;
CREATE TABLE IF NOT EXISTS acl46.t (a int, b text);
CREATE INDEX IF NOT EXISTS acl46_t_idx ON acl46.t (a);
CREATE SEQUENCE IF NOT EXISTS acl46.s;
CREATE OR REPLACE FUNCTION acl46.f() RETURNS int LANGUAGE sql AS 'SELECT 1';
DO $$ BEGIN CREATE TYPE acl46.ct AS (x int); EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE FOREIGN DATA WRAPPER acl46_fdw; EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE SERVER acl46_srv FOREIGN DATA WRAPPER acl46_fdw; EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- invalid privilege type per object class (ExecuteGrantStmt errormsg switch).
GRANT INSERT ON SEQUENCE acl46.s TO PUBLIC;
GRANT SELECT ON DATABASE postgres TO PUBLIC;
GRANT SELECT ON SCHEMA acl46 TO PUBLIC;
GRANT SELECT ON FUNCTION acl46.f() TO PUBLIC;
GRANT SELECT ON LANGUAGE sql TO PUBLIC;
GRANT SELECT ON TYPE acl46.ct TO PUBLIC;
GRANT SELECT ON FOREIGN DATA WRAPPER acl46_fdw TO PUBLIC;
GRANT SELECT ON FOREIGN SERVER acl46_srv TO PUBLIC;
GRANT INSERT ON LARGE OBJECT 999999 TO PUBLIC;

-- grant options can only be granted to individual roles, not PUBLIC.
GRANT SELECT ON acl46.t TO PUBLIC WITH GRANT OPTION;

-- column-privilege structural errors.
GRANT SELECT (nocol) ON acl46.t TO PUBLIC;
GRANT USAGE (a) ON acl46.t TO PUBLIC;
GRANT SELECT (a) ON SEQUENCE acl46.s TO PUBLIC;

-- relkind mismatches surfaced inside ExecGrant_Relation.
GRANT USAGE ON acl46.t TO PUBLIC;
GRANT SELECT ON acl46.acl46_t_idx TO PUBLIC;
GRANT SELECT ON acl46.ct TO PUBLIC;
GRANT USAGE ON SEQUENCE acl46.t TO PUBLIC;

-- nonexistent grantee / object in GRANT and REVOKE.
GRANT SELECT ON acl46.t TO acl_nobody46;
REVOKE SELECT ON acl46.t FROM acl_nobody46;
GRANT SELECT ON ALL TABLES IN SCHEMA acl46_nope TO PUBLIC;

-- aclitem input parsing and has_*_privilege argument errors (acl.c).
SELECT 'garbage'::aclitem;
SELECT 'acl_nobody46=X/postgres'::aclitem;
SELECT 'postgres=Z/postgres'::aclitem;
SELECT has_table_privilege('acl_nobody46', 'acl46.t', 'SELECT');
SELECT has_table_privilege('acl46.t', 'NOSUCHPRIV');
