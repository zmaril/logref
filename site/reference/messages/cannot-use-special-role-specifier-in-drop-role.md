---
message: "cannot use special role specifier in DROP ROLE"
slug: cannot-use-special-role-specifier-in-drop-role
passthrough: false
api: [ereport]
level: [ERROR]
sqlstate:
  - symbol: ERRCODE_INVALID_PARAMETER_VALUE
    code: "22023"
call_sites:
  - "postgres/src/backend/commands/user.c:1130"
reproduced: false
---

# `cannot use special role specifier in DROP ROLE`

## What it means

A `DROP ROLE` named a special role keyword such as `PUBLIC`, `CURRENT_ROLE`, `CURRENT_USER`, or `SESSION_USER` instead of a concrete role name. Those keywords are not droppable roles, so the command is rejected.

## When it happens

It occurs when `DROP ROLE` is written with a role specifier keyword rather than an actual role name.

## How to fix

Name the actual role to drop. Replace the keyword with the concrete role name, and confirm you intend to remove that specific role.

## Example

*Illustrative* — DROP ROLE with a special specifier.

```sql
DROP ROLE CURRENT_USER;
-- ERROR:  cannot use special role specifier in DROP ROLE
```

## Related

- [cannot use](./cannot-use.md)
- [cannot use serializable mode in a hot standby](./cannot-use-serializable-mode-in-a-hot-standby.md)
