---
message: "permission denied to create role"
slug: permission-denied-to-create-role
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INSUFFICIENT_PRIVILEGE
    code: "42501"
call_sites:
  - "postgres/src/backend/commands/user.c:323"
  - "postgres/src/backend/commands/user.c:329"
  - "postgres/src/backend/commands/user.c:335"
  - "postgres/src/backend/commands/user.c:341"
  - "postgres/src/backend/commands/user.c:347"
reproduced: false
---

# `permission denied to create role`

## What it means

The current role tried to create a role but is not allowed to. Creating roles requires the `CREATEROLE` attribute (or superuser). Without it, `CREATE ROLE`/`CREATE USER` is refused.

## When it happens

Running `CREATE ROLE`/`CREATE USER` as a role that has neither superuser status nor the `CREATEROLE` privilege — or trying to create a role with attributes (like `SUPERUSER`) that even a `CREATEROLE` role may not grant.

## How to fix

Perform the creation as a superuser, or grant the acting role `CREATEROLE` (`ALTER ROLE r CREATEROLE`). Be aware a `CREATEROLE` role cannot create superusers or grant attributes it does not itself possess; use a superuser for those.

## Example

*Illustrative* — creating a role without CREATEROLE.

```sql
CREATE ROLE app LOGIN;
```

## Related

- [role name is reserved](./role-name-is-reserved.md)
- [permission denied to terminate process](./permission-denied-to-terminate-process.md)
