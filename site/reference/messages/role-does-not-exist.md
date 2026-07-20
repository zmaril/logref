---
message: "role \"%s\" does not exist"
slug: role-does-not-exist
passthrough: false
api: [ereport]
level: [ERROR, FATAL, NOTICE]
sqlstate:
  - symbol: ERRCODE_INVALID_AUTHORIZATION_SPECIFICATION
    code: "28000"
  - symbol: ERRCODE_UNDEFINED_OBJECT
    code: "42704"
call_sites:
  - "postgres/src/backend/commands/user.c:1140"
  - "postgres/src/backend/commands/user.c:1368"
  - "postgres/src/backend/commands/variable.c:862"
  - "postgres/src/backend/commands/variable.c:981"
  - "postgres/src/backend/utils/adt/acl.c:5615"
  - "postgres/src/backend/utils/adt/acl.c:5663"
  - "postgres/src/backend/utils/adt/acl.c:5691"
  - "postgres/src/backend/utils/adt/acl.c:5710"
  - "postgres/src/backend/utils/init/miscinit.c:752"
reproduced: false
---

# `role "%s" does not exist`

## What it means

A statement referenced a role (user or group) that does not exist. The placeholder is the role name. It appears at `ERROR` for SQL that names a missing role, `FATAL` at connection time when the login role is unknown, and `NOTICE` for `DROP ROLE IF EXISTS` on an absent role.

## When it happens

`GRANT`/`ALTER`/`DROP`/`SET ROLE`/`REASSIGN OWNED` naming a missing role, connecting as a role that was dropped or never created, or `GRANT ... TO` a non-existent grantee. A misspelled or case-sensitive role name is a frequent cause.

## How to fix

Check the role exists with `\du` (or `SELECT rolname FROM pg_roles`). Create it if needed (`CREATE ROLE name`), or correct the spelling — roles created with quoted, mixed-case names must be referenced the same way. For a failed login, confirm the login role name matches what the client sends.

## Example

*Illustrative* — granting to a missing role.

```sql
GRANT SELECT ON t TO analysts;
```

Produces:

```text
ERROR:  role "analysts" does not exist
```

## Related

- [role %s is a member of role %s](./role-is-a-member-of-role.md)
- [permission denied to alter role](./permission-denied-to-alter-role.md)
