-- Roles, membership, reserved names, SET ROLE / SESSION AUTHORIZATION  ->  src/backend/commands/user.c, src/backend/commands/variable.c, src/backend/utils/init/miscinit.c
-- Reserved-name and duplicate-role checks, role-membership validation
-- (self/circular membership, pg_database_owner cannot be a member and cannot
-- have members), then permission-denied paths reached by SET ROLE into an
-- unprivileged role. Idempotent role setup with DO-guards for the shared cluster.

DO $$ BEGIN CREATE ROLE acl_low NOLOGIN; EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE ROLE acl_m1 NOLOGIN; EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE ROLE acl_m2 NOLOGIN; EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN CREATE ROLE acl_dup48 NOLOGIN; EXCEPTION WHEN duplicate_object THEN NULL; END $$;

-- reserved role names and duplicates (CreateRole).
CREATE ROLE pg_acl_test;
CREATE ROLE public;
CREATE ROLE acl_dup48;

-- altering / dropping roles that don't exist or are reserved.
ALTER ROLE acl_nope48 SUPERUSER;
DROP ROLE acl_nope48;
ALTER ROLE pg_read_all_data CONNECTION LIMIT 5;
DROP ROLE pg_read_all_data;

-- role membership: self, circular, nonexistent, and pg_database_owner limits.
GRANT acl_m1 TO acl_m1;
GRANT acl_m1 TO acl_m2;
GRANT acl_m2 TO acl_m1;
GRANT acl_m1 TO acl_nope48;
REVOKE acl_m2 FROM acl_nope48;
REVOKE acl_m1 FROM acl_m2;
GRANT acl_m1 TO pg_database_owner;
GRANT pg_database_owner TO acl_m1;

-- bad CREATE ROLE options.
CREATE ROLE acl_vu48 VALID UNTIL 'not a date';
CREATE ROLE acl_cl48 CONNECTION LIMIT -5;

-- SET ROLE / SET SESSION AUTHORIZATION to a nonexistent role (variable.c).
SET ROLE acl_nope48;
SET SESSION AUTHORIZATION acl_nope48;
RESET ROLE;
RESET SESSION AUTHORIZATION;

-- permission-denied paths reached once the session user is unprivileged.
-- (SET ROLE checks the *session* user, so we must switch it, not just SET ROLE.)
SET SESSION AUTHORIZATION acl_low;
SET ROLE acl_m1;
SET SESSION AUTHORIZATION acl_m1;
CREATE ROLE acl_x48;
DROP ROLE acl_m1;
ALTER ROLE acl_m1 NOLOGIN;
RESET SESSION AUTHORIZATION;
RESET ROLE;
