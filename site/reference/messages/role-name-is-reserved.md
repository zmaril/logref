---
message: "role name \"%s\" is reserved"
slug: role-name-is-reserved
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_RESERVED_NAME
    code: "42939"
call_sites:
  - "postgres/src/backend/commands/user.c:359"
  - "postgres/src/backend/commands/user.c:1397"
  - "postgres/src/backend/commands/user.c:1404"
  - "postgres/src/backend/utils/adt/acl.c:5760"
  - "postgres/src/backend/utils/adt/acl.c:5766"
  - "postgres/src/backend/utils/adt/ddlutils.c:185"
reproduced: true
---

# `role name "%s" is reserved`

## What it means

An attempt to create or rename a role used a name that Postgres reserves for itself. Names beginning with `pg_` are reserved for built-in and system-managed roles, so user code may not claim them.

## When it happens

Running `CREATE ROLE`/`CREATE USER` or `ALTER ROLE ... RENAME TO` with a name that starts with the `pg_` prefix.

## How to fix

Choose a name that does not begin with `pg_`. That prefix is set aside for predefined roles (like `pg_read_all_data`) and future system roles; pick any other identifier for your own roles.

## Example

*Reproduced* — captured from `reproducers/scenarios/48_roles_membership_reserved.sql`.

```sql
CREATE ROLE pg_acl_test;
```

Produces:

```text
ERROR:  role name "pg_acl_test" is reserved
```

## Related

- [permission denied to create role](./permission-denied-to-create-role.md)
- [string is not a valid identifier](./string-is-not-a-valid-identifier.md)
