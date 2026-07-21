---
message: "current user cannot be dropped"
slug: current-user-cannot-be-dropped
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_OBJECT_IN_USE
    code: "55006"
call_sites:
  - "postgres/src/backend/commands/user.c:1158"
  - "postgres/src/backend/commands/user.c:1162"
reproduced: false
---

# `current user cannot be dropped`

## What it means

A `DROP ROLE` (or `DROP USER`) named the role that the current session is running as. A session cannot drop the very role it is authenticated as.

## When it happens

Running `DROP ROLE` on the session's own current user, or on the session's original login role while `SET ROLE` is in effect.

## How to fix

Connect as a different superuser or role-administering role to drop the target, or `RESET ROLE`/switch identity first. You cannot remove the identity your session is currently using.

## Example

*Illustrative* — dropping the session's own role.

```text
ERROR:  current user cannot be dropped
```

## Related

- [dependent privileges exist](./dependent-privileges-exist.md)
- [create specifies a schema different from the one being created](./create-specifies-a-schema-different-from-the-one-being-created.md)
