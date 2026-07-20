---
message: "permission denied to reassign objects"
slug: permission-denied-to-reassign-objects
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/commands/user.c:1636"
  - "postgres/src/backend/commands/user.c:1647"
reproduced: false
---

# `permission denied to reassign objects`

## What it means

A `REASSIGN OWNED` was refused because the current user is not entitled to reassign the objects from the source role to the target role. Reassigning ownership requires rights over both roles involved.

## When it happens

It arises from `REASSIGN OWNED BY old_role TO new_role` when the executing user is neither a superuser nor a member of both the source and destination roles.

## How to fix

Run the command as a superuser, or as a role that is a member of both the role losing ownership and the role gaining it. Obtain the needed memberships first if delegation is preferred.

## Example

*Illustrative* — reassigning objects without membership in both roles.

```text
ERROR:  permission denied to reassign objects
```

## Related

- [permission denied to rename role](./permission-denied-to-rename-role.md)
- [permission denied to grant role "%s"](./permission-denied-to-grant-role.md)
