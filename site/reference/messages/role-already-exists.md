---
message: "role \"%s\" already exists"
slug: role-already-exists
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_DUPLICATE_OBJECT
    code: "42710"
call_sites:
  - "postgres/src/backend/commands/user.c:382"
  - "postgres/src/backend/commands/user.c:1421"
reproduced: false
---

# `role "%s" already exists`

## What it means

A `CREATE ROLE`/`CREATE USER`/`CREATE GROUP` named a role that already exists. The placeholder is the role name. Role names are shared cluster-wide and must be unique.

## When it happens

It arises when creating a role whose name is already taken — a re-run provisioning script, or a collision with an existing login or group role.

## How to fix

Use a different name, or modify the existing role with `ALTER ROLE` instead of creating it. Make provisioning idempotent (check `pg_roles` first, or use tooling that skips existing roles). Drop the old role only if you truly intend to replace it.

## Example

*Illustrative* — creating a role that already exists.

```text
ERROR:  role "app_user" already exists
```

## Related

- [permission denied to rename role](./permission-denied-to-rename-role.md)
- [role name "%s" contains a newline or carriage return character](./role-name-contains-a-newline-or-carriage-return-character.md)
