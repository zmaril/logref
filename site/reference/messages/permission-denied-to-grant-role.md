---
message: "permission denied to grant role \"%s\""
slug: permission-denied-to-grant-role
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/commands/user.c:2148"
  - "postgres/src/backend/commands/user.c:2171"
reproduced: false
---

# `permission denied to grant role "%s"`

## What it means

A `GRANT rolename TO ...` was refused because the current user lacks the admin option on the role being granted. The placeholder is that role. Granting membership in a role requires admin rights over it.

## When it happens

It arises when adding a member to a role without holding `ADMIN OPTION` (or the equivalent) on that role, and without being a superuser.

## How to fix

Have the role's owner, a member with `ADMIN OPTION`, or a superuser perform the grant — or first obtain admin option on the role (`GRANT role TO you WITH ADMIN OPTION`).

## Example

*Illustrative* — granting membership without admin option.

```text
ERROR:  permission denied to grant role "app_admin"
```

## Related

- [permission denied to revoke role "%s"](./permission-denied-to-revoke-role.md)
- [permission denied to grant privileges as role "%s"](./permission-denied-to-grant-privileges-as-role.md)
