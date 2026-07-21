---
message: "permission denied to drop role"
slug: permission-denied-to-drop-role
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/commands/user.c:1105"
  - "postgres/src/backend/commands/user.c:1176"
  - "postgres/src/backend/commands/user.c:1182"
reproduced: true
---

# `permission denied to drop role`

## What it means

The current role tried to drop a role it is not permitted to drop. Dropping a role requires the `CREATEROLE` privilege, and for roles with elevated attributes, superuser status or admin membership.

## When it happens

Running `DROP ROLE` as a role without `CREATEROLE`, or against a role whose attributes require more authority than the requester holds — for example a superuser role dropped by a non-superuser.

## How to fix

Perform the drop as a role with sufficient authority — one holding `CREATEROLE` and admin rights over the target, or a superuser for privileged targets. Grant `CREATEROLE` if a role should manage other roles, keeping in mind the security reach it confers.

## Example

*Reproduced* — captured from `reproducers/scenarios/48_roles_membership_reserved.sql`.

```sql
DROP ROLE acl_m1;
```

Produces:

```text
ERROR:  permission denied to drop role
```

## Related

- [permission denied](./permission-denied.md)
- [role with oid does not exist](./role-with-oid-does-not-exist.md)
