---
message: "permission denied to revoke role \"%s\""
slug: permission-denied-to-revoke-role
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/commands/user.c:2155"
  - "postgres/src/backend/commands/user.c:2178"
reproduced: false
---

# `permission denied to revoke role "%s"`

## What it means

A `REVOKE rolename FROM ...` was refused because the current user lacks admin option on the role being revoked. The placeholder is that role. Revoking membership requires the same admin rights as granting it.

## When it happens

It arises when removing a member from a role without holding `ADMIN OPTION` on that role and without being a superuser.

## How to fix

Have the role's owner, a member with `ADMIN OPTION`, or a superuser perform the revoke, or obtain admin option on the role first.

## Example

*Illustrative* — revoking membership without admin option.

```text
ERROR:  permission denied to revoke role "app_admin"
```

## Related

- [permission denied to grant role "%s"](./permission-denied-to-grant-role.md)
- [permission denied to reassign objects](./permission-denied-to-reassign-objects.md)
