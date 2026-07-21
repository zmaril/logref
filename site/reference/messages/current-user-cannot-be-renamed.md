---
message: "current user cannot be renamed"
slug: current-user-cannot-be-renamed
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_FEATURE_NOT_SUPPORTED
    code: "0A000"
call_sites:
  - "postgres/src/backend/commands/user.c:1388"
reproduced: false
---

# `current user cannot be renamed`

## What it means

An `ALTER ROLE ... RENAME TO` tried to rename the role that the current session is logged in as. A session cannot rename the role it is authenticated as while that session is active. The server reports this as an unsupported case.

## When it happens

It happens when you run `ALTER ROLE current_role RENAME TO ...` in a session connected as that same role.

## How to fix

Connect as a different role — another superuser or a role with the right to rename roles — and rename the target role from there. You cannot rename the identity the current session is using.

## Example

*Illustrative* — renaming the logged-in role.

```sql
-- connected as "app"
ALTER ROLE app RENAME TO app2;
-- ERROR:  current user cannot be renamed
```

## Related

- [creation of new role failed](./creation-of-new-role-failed.md)
- [database is a system database](./database-is-a-system-database.md)
