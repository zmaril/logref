---
message: "permission denied to rename role"
slug: permission-denied-to-rename-role
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/commands/user.c:1432"
  - "postgres/src/backend/commands/user.c:1442"
reproduced: false
---

# `permission denied to rename role`

## What it means

An `ALTER ROLE ... RENAME TO` was refused because the current user lacks the authority to rename the target role. Renaming a role requires `CREATEROLE` plus the right to administer that role, or superuser status.

## When it happens

It arises when a role without sufficient privilege tries to rename another role, or to rename a role it does not have admin rights over.

## How to fix

Perform the rename as a superuser, or as a role with `CREATEROLE` that has admin rights over the target role. Note that some special roles cannot be renamed at all.

## Example

*Illustrative* — renaming a role without the needed rights.

```text
ERROR:  permission denied to rename role
```

## Related

- [permission denied to reassign objects](./permission-denied-to-reassign-objects.md)
- [role "%s" already exists](./role-already-exists.md)
