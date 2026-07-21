-- RLS policies + ALTER DEFAULT PRIVILEGES  ->  src/backend/commands/policy.c, src/backend/rewrite/rewriteHandler.c, src/backend/parser/parse_agg.c, src/backend/catalog/aclchk.c
-- CREATE/ALTER/DROP POLICY validation ereports (not-a-table, system catalog,
-- WITH CHECK vs USING per command, duplicate/missing policy, aggregate/window in
-- policy expressions), the RLS infinite-recursion detector, non-owner RLS ALTER,
-- and the ALTER DEFAULT PRIVILEGES validations. Idempotent for the shared cluster.

DO $$ BEGIN CREATE ROLE acl_low NOLOGIN; EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE ROLE acl_owner49 NOLOGIN; EXCEPTION WHEN duplicate_object THEN NULL; END $$;
CREATE SCHEMA IF NOT EXISTS acl49;
CREATE TABLE IF NOT EXISTS acl49.t (a int, tenant text);
CREATE TABLE IF NOT EXISTS acl49.r (a int);
CREATE SEQUENCE IF NOT EXISTS acl49.s;
GRANT USAGE ON SCHEMA acl49 TO acl_low;
GRANT SELECT ON acl49.t, acl49.r TO acl_low;

-- CREATE POLICY target validation.
CREATE POLICY p ON acl49_nope USING (true);
CREATE POLICY p ON acl49.s USING (true);
CREATE POLICY p ON pg_class USING (true);

-- WITH CHECK vs USING per command (policy.c).
CREATE POLICY p_sel ON acl49.t FOR SELECT WITH CHECK (a > 0);
CREATE POLICY p_del ON acl49.t FOR DELETE WITH CHECK (a > 0);
CREATE POLICY p_ins ON acl49.t FOR INSERT USING (a > 0);

-- duplicate / missing policy.
DROP POLICY IF EXISTS p_dup ON acl49.t;
CREATE POLICY p_dup ON acl49.t USING (true);
CREATE POLICY p_dup ON acl49.t USING (true);
ALTER POLICY p_nope ON acl49.t USING (true);
DROP POLICY p_nope ON acl49.t;

-- policy TO nonexistent role; aggregate / window in a policy expression.
CREATE POLICY p_role ON acl49.t TO acl_nope49 USING (true);
CREATE POLICY p_agg ON acl49.t USING (count(*) > 0);
CREATE POLICY p_win ON acl49.t USING (sum(a) OVER () > 0);

-- RLS infinite recursion: a self-referential policy read as a non-owner.
ALTER TABLE acl49.r ENABLE ROW LEVEL SECURITY;
ALTER TABLE acl49.r FORCE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS p_rec ON acl49.r;
CREATE POLICY p_rec ON acl49.r USING (a IN (SELECT a FROM acl49.r));
SET ROLE acl_low;
SELECT * FROM acl49.r;
RESET ROLE;

-- non-owner cannot enable RLS (ownership check).
SET ROLE acl_low;
ALTER TABLE acl49.t ENABLE ROW LEVEL SECURITY;
RESET ROLE;

-- ALTER DEFAULT PRIVILEGES validations (aclchk.c SetDefaultACL path).
ALTER DEFAULT PRIVILEGES FOR ROLE acl_nope49 GRANT SELECT ON TABLES TO acl_low;
ALTER DEFAULT PRIVILEGES IN SCHEMA acl49_nope GRANT SELECT ON TABLES TO acl_low;
ALTER DEFAULT PRIVILEGES GRANT USAGE ON TABLES TO acl_low;
ALTER DEFAULT PRIVILEGES GRANT SELECT ON FUNCTIONS TO acl_low;
ALTER DEFAULT PRIVILEGES GRANT EXECUTE ON SEQUENCES TO acl_low;
ALTER DEFAULT PRIVILEGES GRANT SELECT ON SCHEMAS TO acl_low;
ALTER DEFAULT PRIVILEGES IN SCHEMA acl49 GRANT USAGE ON SCHEMAS TO acl_low;
ALTER DEFAULT PRIVILEGES GRANT SELECT ON TABLES TO acl_nope49;
SET ROLE acl_low;
ALTER DEFAULT PRIVILEGES FOR ROLE acl_owner49 GRANT SELECT ON TABLES TO acl_low;
RESET ROLE;
